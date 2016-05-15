//
//  AddReviewViewModelTests.swift
//  reviews
//
//  Created by Alessio Borraccino on 16/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import reviews

class AddReviewViewModelTests: XCTestCase {

    private let reviewAPI = ReviewAPIMock()
    private lazy var addReviewViewModel : AddReviewViewModelType = AddReviewViewModel(reviewAPI: self.reviewAPI)

    func didTryToSaveNotValidReview() {
        setInvalidValues()

        let expectation = expectationWithDescription("invalid values")
        addReviewViewModel.didTryToSaveNotValidReview.observeNext { 
            expectation.fulfill()
        }
        addReviewViewModel.addReview()
        waitForExpectationsWithTimeout(0.001, handler: nil)
    }

    func testSaveReview() {
        setValidValues()
        let expectation = expectationWithDescription("valid values")
        addReviewViewModel.didSaveReview.observeNext { review in
            if let _ = review {
                expectation.fulfill()
            } else {
                XCTFail("No Review saved")
            }
        }
        addReviewViewModel.addReview()
        waitForExpectationsWithTimeout(0.001, handler: nil)
    }

    private func setValidValues() {
        addReviewViewModel.author = "Author"
        addReviewViewModel.message = "Message"
        addReviewViewModel.title = "Title"
    }
    private func setInvalidValues() {
        addReviewViewModel.author = "Author"
        addReviewViewModel.message = ""
        addReviewViewModel.title = ""
    }

}
