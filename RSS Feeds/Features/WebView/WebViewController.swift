//
//  WebViewController.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private lazy var webView = WKWebView()
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeScreen))
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.load(URLRequest(url: url))
    }
    
    @objc private func closeScreen() {
        MainNavigationViewController.shared.dismiss(animated: true)
    }
}
