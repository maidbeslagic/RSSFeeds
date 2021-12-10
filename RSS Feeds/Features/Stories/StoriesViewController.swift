//
//  StoriesViewController.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 6. 12. 2021..
//

import UIKit
import SnapKit
import FeedKit
import RxSwift

final class StoriesViewController: UIViewController {
    //MARK: Variables & Constants
    private var viewModel: StoriesViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: Views
    private lazy var tableView = UITableView(frame: .zero, style: .plain) {
        didSet {
            configureTableView()
        }
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        setupObservers()
    }
    
    //MARK: Functions
    func set(link: String) {
        viewModel = StoriesViewModel(topicLink: link)
    }
    
    private func configure() {
        title = Constants.RSSStoriesTitle
        view.addSubview(tableView)
        tableView.backgroundColor = RSSColors.neutralGrey1.uiColor
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(StoriesTableViewCell.self, forCellReuseIdentifier: String(describing: StoriesTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
    }
    
    private func presentAlert(url: URL) {
        let alertVC = UIAlertController(title: "Choose URL Opening", message: "Please choose which way you want the link to be opened.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "External Browser", style: .default, handler: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alertVC.addAction(.init(title: "Built in Browser", style: .default, handler: { _ in
            let webViewVC = WebViewController()
            webViewVC.url = url
            webViewVC.modalPresentationStyle = .popover
            MainNavigationViewController.shared.present(webViewVC, animated: true)
        }))
        alertVC.addAction(.init(title: "Cancel", style: .destructive, handler: { _ in
            alertVC.dismiss(animated: true)
        }))
        present(alertVC, animated: true)
    }
    
    private func setupObservers() {
        viewModel.items.bind(to: tableView.rx.items) { tableView, row, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoriesTableViewCell.self)) as! StoriesTableViewCell
            cell.configure(with: model)
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(StoriesTableViewCellModel.self)
            .subscribe(onNext: { [weak self] model in
                guard
                    let self = self,
                    let urlString = model.link,
                    let url = URL(string: urlString)
                else { return }
                self.presentAlert(url: url)
            }).disposed(by: disposeBag)
    }
}
