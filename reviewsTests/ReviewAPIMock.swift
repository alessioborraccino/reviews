//
//  ReviewAPIMock.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ReactiveCocoa
@testable import reviews

class ReviewAPIMock : ReviewAPI {

    var counter = 0

    override func reviews(count count: Int, pageNumber: Int) -> SignalProducer<[Review],ReviewAPIError> {

        return SignalProducer { [unowned self] observer, disposable in
            let reviews = [
                Review(id: self.counter, title: "number \(self.counter)", foreignLanguage: true),
                Review(id: self.counter+1, title: "number \(self.counter+1)", foreignLanguage: false),
                Review(id: self.counter+2, title: "number \(self.counter+2)", foreignLanguage: true)]
            self.counter += 3
            observer.sendNext(reviews)
            observer.sendCompleted()
        }
    }
}