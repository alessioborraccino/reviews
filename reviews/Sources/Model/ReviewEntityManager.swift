//
//  ReviewEntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol ReviewEntityManagerType : EntityManagerType {
    func all() -> [Review]
    func saveContentsOf(entities: [Review]) -> Bool 
}
class ReviewEntityManager : ReviewEntityManagerType {
    typealias EntityType = Review 
}