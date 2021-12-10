//
//  UIView+Extensions.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import UIKit

extension UIView {
    func setCornerRadius(points: CGFloat) {
        layer.cornerRadius = points
        clipsToBounds = true
    }
}
