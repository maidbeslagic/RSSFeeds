//
//  IndexHrManager.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import Foundation
import FeedKit
import RxSwift
import CoreData

final class IndexHrManager {
    static let shared = IndexHrManager()
    private let disposeBag = DisposeBag()
    private let dataManager = CoreDataManager.shared
    
    private init() { }
    
    func fetch(request: Request) -> Completable {
        return Completable.create { completable in
            request.submit { result in
                switch result {
                case .success(let feed):
                    self.insertTopic(feed: feed) {
                        completable(.completed)
                    }
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func insertTopic(feed: Feed, completion: @escaping () -> Void) {
        guard
            let rssFeed = feed.rssFeed,
            let link = rssFeed.link
        else {
            completion()
            return
        }
        let backgroundMOC = dataManager.backgroundMOC
        backgroundMOC.perform {
            let topic = Topic.insert(link: link, rssFeed: rssFeed, to: backgroundMOC)
            let oldStories = self.fetchStories(topicLink: topic.link, context: backgroundMOC)
            var preservedIds: [NSNumber] = []
            if let stories = rssFeed.items {
                for story in stories {
                    guard
                        let idString = story.guid?.value?.getQueryStringParameter(param: "id"),
                        let intId = Int(idString)
                    else { continue }
                    let id = NSNumber(value: intId)
                    Story.insert(id: id, feedItem: story, topic: topic, to: backgroundMOC)
                    preservedIds.append(id)
                }
            }
            oldStories.filter { !preservedIds.contains($0.id) }.forEach { backgroundMOC.delete($0) }
            backgroundMOC.saveOrRollback()
            completion()
        }
    }
    
    private func fetchStories(topicLink: String, context: NSManagedObjectContext) -> [Story] {
        let request = Story.sortedFetchRequest
        request.predicate = Story.predicate(for: topicLink)
        return (try? context.fetch(request)) ?? []
    }
}
