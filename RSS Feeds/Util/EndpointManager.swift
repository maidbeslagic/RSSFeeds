//
//  EndpointManager.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import Foundation
import FeedKit
import RxSwift

final class EndpointManager {
    static let shared = EndpointManager()
    
    private init() { }
    
    func submit(request: Request) -> Single<Feed> {
        return Single.create { single in
            guard let url = URL(string: request.baseUrl + request.path) else {
                logger.log("FeedManager: URL creation failed", type: .error)
                single(.failure(RSSError.badUrl))
                return Disposables.create()
            }
            
            let parser = FeedParser(URL: url)
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    single(.success(feed))
                case .failure(let parserError):
                    logger.log("Error parsing an RSS feed: \(parserError.localizedDescription)", type: .error)
                    single(.failure(parserError))
                }
            }
            return Disposables.create()
        }
    }
    
    func submit(request: Request, completion: @escaping (Result<Feed, Error>) -> Void) {
        guard let url = URL(string: request.baseUrl + request.path) else {
            logger.log("FeedManager: URL creation failed", type: .error)
            completion(.failure(RSSError.badUrl))
            return
        }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                completion(.success(feed))
            case .failure(let parserError):
                logger.log("Error parsing an RSS feed: \(parserError.localizedDescription)", type: .error)
                completion(.failure(parserError))
            }
        }
            
    }
}

