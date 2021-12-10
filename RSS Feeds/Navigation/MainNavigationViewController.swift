//
//  MainNavigationViewController.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import UIKit

final class MainNavigationViewController: UINavigationController {
    
    static let shared = MainNavigationViewController()
    
    private init() {
        super.init(rootViewController: TopicsViewController())
        setupNavBar()
    }
    
    private func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = RSSColors.neutralGrey8.uiColor
         navigationBar.prefersLargeTitles = true
         navigationBar.isTranslucent = false
         navigationBar.standardAppearance = navBarAppearance
         navigationBar.scrollEdgeAppearance = navBarAppearance
    }
         
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
