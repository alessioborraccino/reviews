//
//  ReviewEntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RealmSwift

protocol ReviewEntityManagerType {
    func all() -> [Review]
    func deleteReviewsNotContainedIn(reviews: [Review]) throws
    func saveContentsOf(entities: [Review]) throws
}

class ReviewEntityManager : ReviewEntityManagerType, EntityManagerType {
    typealias EntityType = Review

    var realm: Realm  {
        return Data.defaultRealm
    }

    func deleteReviewsNotContainedIn(reviews: [Review]) throws {
        let obsoleteReviews = all().filter { cachedReview in
            return !reviews.contains(cachedReview)
        }
        try deleteContentsOf(obsoleteReviews)
    }

}