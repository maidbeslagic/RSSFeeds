//
//  TopicTableViewCell.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 10. 12. 2021..
//

import UIKit
import Kingfisher

final class TopicTableViewCell: UITableViewCell {
    //MARK: Views
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var feedImage = UIImageView()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String(describing: TopicTableViewCell.self))
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    //MARK: Functions
    func configure(with model: TopicTableViewCellModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        if let imageUrl = model.imageUrl, let url = URL(string: imageUrl) {
            feedImage.kf.setImage(with: url)
        } else {
            feedImage.image = UIImage(systemName: "bookmark")
        }
    }
    
    private func clearCell() {
        titleLabel.text = String()
        descriptionLabel.text = String()
        feedImage.image = nil
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-20)
        }
        containerView.backgroundColor = .white
        containerView.setCornerRadius(points: 5)
        
        containerView.addSubview(feedImage)
        feedImage.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        feedImage.setCornerRadius(points: 5)
        feedImage.contentMode = .scaleAspectFit
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(feedImage.snp.trailing).offset(20)
            make.top.equalTo(feedImage.snp.top)
            make.trailing.greaterThanOrEqualToSuperview().offset(10)
        }
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        titleLabel.textColor = RSSColors.neutralGrey8.uiColor
        titleLabel.font = FontStyle.header.font
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(containerView.snp.bottom).offset(10)
        }
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.textColor = RSSColors.neutralGrey8.uiColor
        descriptionLabel.font = FontStyle.body.font
        descriptionLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    }
}
