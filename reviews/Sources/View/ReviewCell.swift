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

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        return label
    }()
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.lightGrayColor()
        selectionStyle = .None
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        setDefaultConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(5)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(containerView.snp_top)
            make.leading.equalTo(containerView.snp_leading)
            make.trailing.equalTo(containerView.snp_trailing)
            make.height.equalTo(44)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(containerView.snp_bottom)
            make.leading.equalTo(containerView.snp_leading)
            make.trailing.equalTo(containerView.snp_trailing)
        }
    }

    func bind(model: ReviewCellViewModel) {
        titleLabel.text = model.title
        messageLabel.text = model.message
    }

}
