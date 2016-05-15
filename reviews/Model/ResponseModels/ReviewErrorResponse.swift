//
//  ReviewAPIErrorResponse.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ObjectMapper

class ReviewErrorResponse : Mappable {

    var message : String?

    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
    }

    func mapping(map: Map) {
        message <- map["message"]
    }
}
