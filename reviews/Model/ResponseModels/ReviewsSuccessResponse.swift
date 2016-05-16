//
//  ReviewsSuccessResponse.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ObjectMapper

class ReviewSuccessResponse : Mappable {

    private(set) var reviews : [Review]?
    private(set) var totalReviews : Int = 0

    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
    }

    func mapping(map: Map) {
        totalReviews <- map["total_reviews"]
        reviews <- map["data"]
    }
}
