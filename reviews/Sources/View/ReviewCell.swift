//
//  ReviewCell.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit

class ReviewCell : UITableViewCell, ReusableType {

    private struct UI {
        static let topBottomPadding : CGFloat = 10.0
        static let padding : CGFloat = 5.0
        static let ratingViewHeight : CGFloat = 40.0

        static let titleFont = AppFont.bold
        static let messageFont = AppFont.regular
        static let footerFont = AppFont.hint
    }

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.textDark
        label.font = UI.titleFont
        label.numberOfLines = 0
        return label
    }()
    private lazy var ratingView : RatingView = RatingView(totalRating: 5)

    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.textDark
        label.font = UI.messageFont
        label.numberOfLines = 0
        return label
    }()
    private lazy var footerLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.textLight
        label.font = UI.footerFont
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(footerLabel)
        setDefaultConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {

        let padding = UI.padding
        let ratingViewHeight = UI.ratingViewHeight
        let topBottomPadding = UI.topBottomPadding

        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top).offset(topBottomPadding)
            make.bottom.equalTo(ratingView.snp_top)
            make.leading.equalTo(contentView.snp_leading).offset(padding)
            make.trailing.equalTo(contentView.snp_trailing).offset(-padding)
        }
        ratingView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom)
            make.leading.equalTo(titleLabel.snp_leading)
            make.trailing.equalTo(titleLabel.snp_trailing)
            make.height.equalTo(ratingViewHeight)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(ratingView.snp_bottom).offset(padding)
            make.bottom.equalTo(footerLabel.snp_top).offset(-padding)
            make.leading.equalTo(titleLabel.snp_leading)
            make.trailing.equalTo(titleLabel.snp_trailing)
        }
        footerLabel.snp_makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp_bottom).offset(padding)
            make.bottom.equalTo(contentView.snp_bottom).offset(-topBottomPadding)
            make.leading.equalTo(titleLabel.snp_leading)
            make.trailing.equalTo(titleLabel.snp_trailing)
        }
    }

    func bind(reviewCellViewModel: ReviewCellViewModelType) {
        titleLabel.text = reviewCellViewModel.title
        ratingView.configureWithRating(reviewCellViewModel.rating)
        messageLabel.text = reviewCellViewModel.message
        footerLabel.text = reviewCellViewModel.footer
    }
    
    static func heightWithViewModel(reviewCellViewModel: ReviewCellViewModelType) -> CGFloat {
        let boundingSize = CGSize(width: UIScreen.mainScreen().bounds.width - (UI.padding * 2), height: 0)
        let titleAttributes = [NSFontAttributeName:UI.titleFont]
        let messageAttributes = [NSFontAttributeName:UI.messageFont]
        let footerAttributes = [NSFontAttributeName:UI.footerFont]

        let titleHeight = reviewCellViewModel.title.boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: titleAttributes, context: nil).height
        let messageHeight = reviewCellViewModel.message.boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: messageAttributes, context: nil).height
        let footerHeight = reviewCellViewModel.footer.boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, attributes: footerAttributes, context: nil).height

        return titleHeight + messageHeight + footerHeight + UI.ratingViewHeight + UI.topBottomPadding * 2 + UI.padding * 3
    }

}
