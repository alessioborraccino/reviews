//
//  FilterSwitchView.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import Result

class FilterSwitchView : UIView {

    // MARK: Subviews 

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.textDark
        label.font = AppFont.regular
        return label
    }()

    private lazy var filterSwitch : UISwitch = {
        let filterSwitch = UISwitch()
        filterSwitch.addTarget(self, action: #selector(didTap), forControlEvents: .TouchUpInside)
        return filterSwitch
    }()

    // MARK: Reactive 

    private lazy var filterOnProperty : MutableProperty<Bool> =  MutableProperty<Bool>(false)

    private(set) lazy var didChangeSwitchTo : SignalProducer<Bool,NoError> = {
        return self.filterOnProperty.producer
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: CGRectZero)

        backgroundColor = UIColor.whiteColor()
        
        addSubview(titleLabel)
        addSubview(filterSwitch)
        setDefaultConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Constraints
    private func setDefaultConstraints() {

        let padding = 5

        titleLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(snp_leading).offset(padding)
            make.trailing.equalTo(filterSwitch.snp_leading).offset(-padding)
            make.centerY.equalTo(snp_centerY)
        }

        filterSwitch.snp_makeConstraints { (make) in
            make.trailing.equalTo(snp_trailing).offset(-padding)
            make.width.equalTo(55)
            make.centerY.equalTo(snp_centerY)
        }
    }

    // MARK: Methods 

    @objc private func didTap() {
        filterOnProperty.value = !filterOnProperty.value
    }
    func configureWithTitle(title: String) {
        titleLabel.text = title
    }
}