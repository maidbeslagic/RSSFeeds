//
//  FontStyle.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import UIKit

enum FontStyle {
    case header, body, smallBody
    
    var fontSize: CGFloat {
        switch self {
        case .header:
            return 17
        case .body:
            return 14
        case .smallBody:
            return 12
        }
    }
    
    var font: UIFont {
        return .systemFont(ofSize: fontSize)
    }
}
