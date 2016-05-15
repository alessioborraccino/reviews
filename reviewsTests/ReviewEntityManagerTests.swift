//
//  reviewsTests.swift
//  reviewsTests
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import reviews

class ReviewEntityManagerTests: RealmTestCase {

    private var testReviewEntityManager : ReviewEntityManager!

    override func setUp() {
        testReviewEntityManager = ReviewEntityManager(realm: testRealm)
        super.setUp()
    }

    func testCacheReviews() {
        XCTAssertEqual(testReviewEntityManager.all().count, 0)
        testReviewEntityManager.cacheReviews([
            Review(id:0),
            Review(id:1),
            Review(id:2)
            ])
        XCTAssertEqual(testReviewEntityManager.all().count, 3)
    }

    func testAllReviews() {
        XCTAssertEqual(testReviewEntityManager.all().count, 0)
        do {
            try testReviewEntityManager.saveContentsOf([
                Review(id:0),
                Review(id:1),
                Review(id:2)
            ])
            XCTAssertEqual(testReviewEntityManager.allReviews().count, 3)
        } catch {
            XCTFail("could not save on test realm")
        }
    }
}
