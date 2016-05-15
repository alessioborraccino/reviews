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
    func allReviews() -> [Review]
    func cacheReviews(reviews: [Review])
}

class ReviewEntityManager : RealmManager, EntityManagerType, ReviewEntityManagerType {

    typealias EntityType = Review

    func allReviews() -> [Review] {
        return Array(realm.objects(EntityType).sorted("reviewID", ascending: false))
    }
    
    func cacheReviews(reviews: [Review]) {
        do {
            try self.saveContentsOf(reviews)
        } catch {
            print("Could not save reviews")
        }
    }
}