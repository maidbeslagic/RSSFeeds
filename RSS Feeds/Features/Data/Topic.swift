//
//  Topic.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import CoreData
import FeedKit

final class Topic: NSManagedObject {
    @NSManaged var link: String
    @NSManaged var title: String?
    @NSManaged var descriptionText: String?
    @NSManaged var imageUrl: String?
    @NSManaged var stories: Set<Story>?
    
    static func insert(link: String, rssFeed: RSSFeed, to context: NSManagedObjectContext) -> Topic {
        let topic = Topic.findOrCreate(for: link, in: context)
        
        topic.title = rssFeed.title
        topic.descriptionText = rssFeed.description
        topic.imageUrl = rssFeed.image?.url
        
        return topic
    }
    
    static func findOrCreate(for link: String, in context: NSManagedObjectContext) -> Topic {
        let predicate = Topic.predicate(for: link)
        let topic = findOrCreateObject(in: context, matching: predicate) {
            $0.link = link
        }
        return topic
    }
    
    static func predicate(for link: String) -> NSPredicate {
        return NSPredicate(format: "%K == %@", #keyPath(Topic.link), link)
    }
}

extension Topic: Managed {
    static var entityName: String {
        return String(describing: Topic.self)
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(link), ascending: true)]
    }
}
