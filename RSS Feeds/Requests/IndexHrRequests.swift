//
//  IndexHrRequests.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import Foundation
import RxSwift
import FeedKit

enum IndexHrRequests: Request, CaseIterable {
    case scienceNews
    case worldNews
    case basketball
    case recipes
    
    var baseUrl: String {
        return Constants.RSSLinks.IndexHrBaseRSS
    }
    
    var path: String {
        switch self {
        case .scienceNews:
            return Constants.RSSTopics.ScienceNews
        case .worldNews:
            return Constants.RSSTopics.WorldNews
        case .basketball:
            return Constants.RSSTopics.Basketball
        case .recipes:
            return Constants.RSSTopics.Recipes
        }
    }
    
    func submit() -> Single<Feed> {
        return EndpointManager.shared.submit(request: self)
    }
    
    func submit(completion: @escaping (Result<Feed, Error>) -> Void) {
        return EndpointManager.shared.submit(request: self, completion: completion)
    }
}
