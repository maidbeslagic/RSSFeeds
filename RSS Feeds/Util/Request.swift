//
//  Request.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import Foundation
import RxSwift
import FeedKit

protocol Request {
    var baseUrl: String { get }
    var path: String { get }
    func submit() -> Single<Feed>
    func submit(completion: @escaping (Result<Feed, Error>) -> Void)
}

