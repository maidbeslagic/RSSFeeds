//
//  RSSColors.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import UIKit

enum RSSColors {
    case neutralGrey1
    case neutralGrey8
    
    var uiColor: UIColor {
        switch self {
        case .neutralGrey1:
            return #colorLiteral(red: 0.9782040715, green: 0.9782040715, blue: 0.9782039523, alpha: 1)
        case .neutralGrey8:
            return #colorLiteral(red: 0.2409569025, green: 0.2753475904, blue: 0.3192713559, alpha: 1)
        }
    }
}
