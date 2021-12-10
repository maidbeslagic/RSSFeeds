//
//  StoriesViewModel.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import Foundation
import FeedKit
import RxSwift
import RxCocoa
import CoreData

final class StoriesViewModel: NSObject {
    //MARK: Constants & Variables
    private let indexHrManager: IndexHrManager
    private let dataManager: CoreDataManager
    private let topicLink: String
    private var storiesFRC: NSFetchedResultsController<Story>!
    let items = BehaviorRelay<[StoriesTableViewCellModel]>(value: [])
    
    init(topicLink: String,
         indexHrManager: IndexHrManager = IndexHrManager.shared,
         dataManager: CoreDataManager = CoreDataManager.shared) {
        self.indexHrManager = indexHrManager
        self.dataManager = dataManager
        self.topicLink = topicLink
        super.init()
        setupStoriesFRC()
        handleData()
    }
    
    private func setupStoriesFRC() {
        let request = Story.sortedFetchRequest
        request.predicate = Story.predicate(for: topicLink)
        storiesFRC = NSFetchedResultsController<Story>(fetchRequest: request,
                                                       managedObjectContext: dataManager.mainMOC,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        storiesFRC.delegate = self
        do { try storiesFRC.performFetch() }
        catch { fatalError("Story fetch failed") }
    }
    
    private func handleData() {
        guard let stories = storiesFRC.fetchedObjects else { return }
        
        var newItems: [StoriesTableViewCellModel] = []
        for story in stories {
            newItems.append(.init(title: story.title ?? String(), description: story.descriptionText ?? String(), link: story.link))
        }
        
        items.accept(newItems)
    }
}

extension StoriesViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.handleData()
        }
    }
}
