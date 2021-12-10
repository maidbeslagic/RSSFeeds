//
//  TopicsViewModel.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class TopicsViewModel: NSObject {
    //MARK: Constants & Variables
    private let indexHrManager: IndexHrManager
    private let dataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    private var topicsFRC: NSFetchedResultsController<Topic>!
    private var hasLoaded = false
    let loadingStream = PublishRelay<Bool>()
    let errorStream = PublishRelay<Void>()
    let items = BehaviorRelay<[TopicTableViewCellModel]>(value: [])
    
    init(indexHrManager: IndexHrManager = IndexHrManager.shared,
         dataManager: CoreDataManager = CoreDataManager.shared) {
        self.indexHrManager = indexHrManager
        self.dataManager = dataManager
        super.init()
        
        setupTopicsFRC()
    }
    
    func fetch(request: Request) {
        loadingStream.accept(true)
        indexHrManager.fetch(request: request)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] in
                guard let self = self else { return }
                self.hasLoaded = true
                self.handleData()
                self.loadingStream.accept(false)
            } onError: { [weak self] _ in
                self?.errorStream.accept(())
                self?.handleData()
                self?.loadingStream.accept(false)
            }.disposed(by: disposeBag)
    }
    
    func fetchAll() {
        let completableList = IndexHrRequests.allCases.map { indexHrManager.fetch(request: $0) }
        Completable.zip(completableList)
            .catch { _ in
                return Completable.empty()
            }.subscribe { [weak self] in
                guard let self = self else { return }
                self.hasLoaded = true
                self.handleData()
                self.loadingStream.accept(false)
            } onError: { [weak self] _ in
                self?.errorStream.accept(())
                self?.handleData()
                self?.loadingStream.accept(false)
            }.disposed(by: disposeBag)
    }
    
    private func setupTopicsFRC() {
        let request = Topic.sortedFetchRequest
        topicsFRC = NSFetchedResultsController<Topic>(fetchRequest: request,
                                                      managedObjectContext: dataManager.mainMOC,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
        topicsFRC.delegate = self
        do { try topicsFRC.performFetch() }
        catch { fatalError("Topic fetch failed!") }
    }
    
    private func handleData() {
        guard hasLoaded else { return }
        
        let topics = topicsFRC.fetchedObjects ?? []
        var newItems: [TopicTableViewCellModel] = []
        
        for topic in topics {
            newItems.append(.init(title: topic.title ?? String(), description: topic.descriptionText ?? String(), imageUrl: topic.imageUrl, link: topic.link))
        }
        
        items.accept(newItems)
    }
}

extension TopicsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.handleData()
        }
    }
}
