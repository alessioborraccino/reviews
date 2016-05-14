//
//  reviewsTests.swift
//  reviewsTests
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RealmSwift
import XCTest
@testable import reviews

class TestReviewEntityManager : ReviewEntityManager {

    private let testRealm : Realm
    init (realm: Realm) {
        self.testRealm = realm
    }
    override var realm: Realm {
        return testRealm
    }
}

class ReviewEntityManagerTests: RealmTestCase {

    private var testReviewEntityManager : TestReviewEntityManager!

    override func setUp() {
        testReviewEntityManager = TestReviewEntityManager(realm: testRealm)
        super.setUp()
    }
    
    func testAllReviews() {
        XCTAssertEqual(testReviewEntityManager.all().count, 0)
        testReviewEntityManager.save(Review(id: 0))
        XCTAssertEqual(testReviewEntityManager.all().count, 1)
        testReviewEntityManager.save(Review(id: 1))
        XCTAssertEqual(testReviewEntityManager.all().count, 2)
    }

    func testSaveContentsOf() {
        XCTAssertEqual(testReviewEntityManager.all().count, 0)
        testReviewEntityManager.saveContentsOf([
            Review(id:0),
            Review(id:1),
            Review(id:2)
            ])
        XCTAssertEqual(testReviewEntityManager.all().count, 3)
    }
}
