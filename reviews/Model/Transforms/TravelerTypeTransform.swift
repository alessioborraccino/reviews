//
//  TravelerTypeTransform.swift
//  reviews
//
//  Created by Alessio Borraccino on 16/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ObjectMapper

class TravelerTypeTransform :TransformType {

    func transformFromJSON(value: AnyObject?) -> TravelerType? {
        if let travelerTypeString = value as? String {
            return TravelerType(rawValue: travelerTypeString)
        }
        return nil
    }

    func transformToJSON(value: TravelerType?) -> String? {
        if let travelerType = value {
            return travelerType.rawValue
        }
        return nil
    }
}