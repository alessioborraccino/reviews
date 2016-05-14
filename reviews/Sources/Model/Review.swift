//
//  Review.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RealmSwift
import ObjectMapper

enum TravelerType : String {
    case Solo = "solo"
    case Couple
    case FamilyYoung
    case FamilyOld
    case Friends
}

class Review : Object, Mappable {
    dynamic var reviewID : Int = 0
    dynamic var rating: Int = 0
    dynamic var title: String = ""
    dynamic var message: String = ""
    dynamic var author: String = ""
    dynamic var foreignLanguage: Bool = false
    dynamic var date: String = ""
    dynamic var languageCode: String = "en"
    var travelerType: TravelerType?

    private dynamic var travelerTypeRaw: String?

    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
    }

    convenience init(id: Int) {
        self.init()
        self.reviewID = id
    }
    override static func primaryKey() -> String? {
        return "reviewID"
    }

    func mapping(map: Map) {
        reviewID <- map["review_id"]
        rating <- (map["rating"], transformRatingIntString())
        title <- map["title"]
        message <- map["message"]
        author <- map["author"]
        foreignLanguage <- map["foreign_language"]
        date <- map["date"]
        languageCode <- map["languageCode"]
        travelerType <- (map["traveler_type"], transformTravelerTypeString())
    }

    private func transformRatingIntString() -> TransformOf<Int, String> {
        return TransformOf<Int, String>(fromJSON: { string in
            if let value = string , double = Double(value) {
                return Int(double)
            } else {
                return 0
            }
        }, toJSON: { rating in
            if let value = rating {
                return String(value) + ".0"
            } else {
                return nil
            }
        })
    }

    private func transformTravelerTypeString() -> TransformOf<TravelerType?, String> {
        return TransformOf<TravelerType?, String>(fromJSON: { string in
            if let value = string {
                return TravelerType(rawValue: value)
            } else {
                return nil
            }
        }, toJSON: { travelerType in
            if let value = travelerType {
                return value?.rawValue
            } else {
                return nil
            }
        })
    }
}
