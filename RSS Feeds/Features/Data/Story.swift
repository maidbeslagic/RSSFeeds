//
//  Story.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import CoreData
import FeedKit

final class Story: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var title: String?
    @NSManaged var descriptionText: String?
    @NSManaged var link: String?
    @NSManaged var topic: Topic?
    @NSManaged var topicLink: String
    
    @discardableResult
    static func insert(id: NSNumber, feedItem: RSSFeedItem, topic: Topic, to context: NSManagedObjectContext) -> Story {
        let story = Story.findOrCreate(for: id, and: topic.link, in: context)
        
        story.title = feedItem.title
        story.descriptionText = feedItem.description
        story.link = feedItem.link
        story.topic = topic
        
        return story
    }
    
    static func findOrCreate(for id: NSNumber, and topicLink: String, in context: NSManagedObjectContext) -> Story {
        let predicate = Story.predicate(for: id, and: topicLink)
        let story = findOrCreateObject(in: context, matching: predicate) {
            $0.id = id
            $0.topicLink = topicLink
        }
        return story
    }
    
    static func predicate(for id: NSNumber, and topicLink: String) -> NSPredicate {
        return NSPredicate(format: "%K == %@ && %K == %@",
                           #keyPath(Story.id), id,
                           #keyPath(Story.topicLink), topicLink)
    }
    
    static func predicate(for topicLink: String) -> NSPredicate {
        return NSPredicate(format: "%K == %@", #keyPath(Story.topicLink), topicLink)
    }
}

extension Story: Managed {
    static var entityName: String {
        return String(describing: Story.self)
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
}
