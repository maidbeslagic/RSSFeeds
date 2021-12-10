//
//  String+Extensions.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import Foundation

extension String {
    func getQueryStringParameter(param: String) -> String? {
      guard let url = URLComponents(string: self) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
