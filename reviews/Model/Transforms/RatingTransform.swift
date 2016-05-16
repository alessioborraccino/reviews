//
//  RatingTransform.swift
//  reviews
//
//  Created by Alessio Borraccino on 16/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ObjectMapper

class RatingTransform : TransformType {

    func transformFromJSON(value: AnyObject?) -> Int? {
        if let ratingString = value as? String, ratingDouble = Double(ratingString) {
            return Int(ratingDouble)
        } else {
            return 0
        }
    }

    func transformToJSON(value: Int?) -> String? {
        if let rating = value {
            return String(rating) + ".0"
        } else {
            return nil
        }
    }
}