//
//  UITextField+RAC.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

extension UITextField {

    func racTextChanged() -> SignalProducer<String?,NoError> {
        return rac_signalForControlEvents(.EditingChanged)
            .toSignalProducer()
            .map { [unowned self] _ in
                return self.text
            }.flatMapError { _ in
                return SignalProducer<String?, NoError>.empty
        }
    }
}
extension UITextView {

    func racTextChanged() -> SignalProducer<String?,NoError> {
        return rac_textSignal()
            .toSignalProducer()
            .map { [unowned self] _ in
                return self.text
            }.flatMapError { _ in
                return SignalProducer<String?, NoError>.empty
        }
    }
}