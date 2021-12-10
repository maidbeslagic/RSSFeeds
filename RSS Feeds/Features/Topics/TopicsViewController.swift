//
//  TopicsViewController.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 6. 12. 2021..
//

import UIKit
import SnapKit
import RxSwift

final class TopicsViewController: UIViewController {
    //MARK: Variables & Constants
    private let viewModel = TopicsViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: Views
    private lazy var tableView = UITableView(frame: .zero, style: .plain) {
        didSet {
            configureTableView()
        }
    }
    private lazy var spinnerView = UIActivityIndicatorView(style: .large)
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        setupObservers()
        viewModel.fetchAll()
    }
    
    //MARK: Functions
    private func configure() {
        title = Constants.RSSTopicsTitle
        
        view.addSubview(tableView)
        tableView.backgroundColor = RSSColors.neutralGrey1.uiColor
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(100)
        }
        spinnerView.isHidden = true
    }
    private func configureTableView() {
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: String(describing: TopicTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
    }
    
    private func setupObservers() {
        viewModel.loadingStream
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.spinnerView.isHidden = !status
                status ? self.spinnerView.startAnimating() : self.spinnerView.stopAnimating()
            }).disposed(by: disposeBag)
        
        viewModel.errorStream
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showError()
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(TopicTableViewCellModel.self)
            .subscribe(onNext: { model in
                let vc = StoriesViewController()
                vc.set(link: model.link)
                MainNavigationViewController.shared.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        
        viewModel.items.bind(to: tableView.rx.items) { tableView, row, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicTableViewCell.self)) as? TopicTableViewCell else { fatalError("Wrong Cell Identifier") }
            cell.configure(with: model)
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func showError() {
        let alertVC = UIAlertController(title: "Ooops!", message: "Something went wrong.", preferredStyle: .alert)
        present(alertVC, animated: true)
    }
}
