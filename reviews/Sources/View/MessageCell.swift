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
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5
        view.layer.borderColor = AppColor.textDark.CGColor
        view.layer.borderWidth = 2
        return view
    }()

    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()

    private lazy var activityIndicatorView : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(activityIndicatorView)
        
        setDefaultConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {

        let padding = 10

        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(padding)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(containerView.snp_top)
            make.bottom.equalTo(containerView.snp_bottom)
            make.leading.equalTo(containerView.snp_leading).offset(padding)
            make.trailing.equalTo(containerView.snp_trailing).offset(-padding)
        }
        activityIndicatorView.snp_makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }

    func bind<T: MessageCellViewModelType>(messageCellViewModel viewModel: T) {
        if viewModel.isLoading {
            messageLabel.text = ""
            activityIndicatorView.startAnimating()
        } else {
            messageLabel.text = viewModel.message
            activityIndicatorView.stopAnimating()
        }
    }

    static func height() -> CGFloat {
        return 100
    }
}
