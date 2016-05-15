//
//  ReviewsViewModelTests.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import reviews

class ReviewsViewModelTests: RealmTestCase {

    private lazy var reviewEntityManager : ReviewEntityManagerType = ReviewEntityManager(realm: self.testRealm)
    private let reviewsAPI : ReviewAPIType = ReviewAPIMock()
    private let reviewCellViewModelFactory = ReviewCellViewModelFactory()
    private let messageCellViewModelFactory = MessageCellViewModelFactory()

    private lazy var reviewsViewModel : ReviewsViewModelType = {
        return ReviewsViewModel(reviewEntityManager: self.reviewEntityManager,
                                          reviewAPI: self.reviewsAPI,
                         reviewCellViewModelFactory: self.reviewCellViewModelFactory,
                        messageCellViewModelFactory: self.messageCellViewModelFactory)
    }()

    override func setUp() {
        super.setUp()
    }

    func testIndexPaths() {
        //TODO
    }

    func testLoadReviews() {
        XCTAssertEqual(reviewsViewModel.reviewsCount,0)
        reviewsViewModel.loadReviews()
        XCTAssertEqual(reviewsViewModel.reviewsCount,3)
    }
    func testReviewsCount() {
        reviewsViewModel.loadReviews()
        XCTAssertEqual(reviewsViewModel.reviewsCount,3)
    }
    func testShowForeignLanguageReviews() {
        reviewsViewModel.loadReviews()
        reviewsViewModel.showForeignLanguageReviews(false)
        XCTAssertEqual(reviewsViewModel.reviewsCount,1)
    }
    func testCacheReviews() {
        reviewsViewModel.loadReviews()
        XCTAssertEqual(reviewEntityManager.allReviews().count,0)
        reviewsViewModel.cacheReviews()
        XCTAssertEqual(reviewEntityManager.allReviews().count,3)
    }
    func testReviewCellViewModel() {
        reviewsViewModel.loadReviews()
        let firstCellModel = reviewsViewModel.reviewCellViewModelForIndex(0)
        let secondCellModel = reviewsViewModel.reviewCellViewModelForIndex(1)
        XCTAssertEqual(firstCellModel.title, "number 0")
        XCTAssertEqual(secondCellModel.title, "number 1")
    }
    func testMessageCellViewModel(){
        reviewsViewModel.loadReviews()
        let messageCellModel = reviewsViewModel.messageCellViewModel()
        XCTAssertEqual(messageCellModel.message, MessageCellState.WaitingToLoad.description)
    }
}
