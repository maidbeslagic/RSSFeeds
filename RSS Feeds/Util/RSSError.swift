//
//  RSSError.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import Foundation

enum RSSError: Error, LocalizedError {
    case badUrl
    
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Bad URL path!"
        }
    }
}
