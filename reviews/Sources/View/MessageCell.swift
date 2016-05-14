//
//  ReviewCell.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit

class MessageCell : UITableViewCell, ReusableType {

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cyanColor()
        return view
    }()

    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(containerView)
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
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(containerView.snp_top)
            make.bottom.equalTo(containerView.snp_bottom)
            make.leading.equalTo(containerView.snp_leading)
            make.trailing.equalTo(containerView.snp_trailing)
        }
    }

    func bind(viewModel viewModel: MessageCellViewModel) {
        messageLabel.text = viewModel.message
    }

}
