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
    case Couple = "couple"
    case FamilyYoung = "family_young"
    case FamilyOld = "family_old"
    case Friends = "friends"
}

// MARK : Equatable

func == (lhs: Review, rhs: Review) -> Bool {
    return lhs.reviewID == rhs.reviewID
}

class Review : Object, Mappable {

    // MARK: Realm saved properties 

    dynamic var reviewID : Int = 0
    dynamic var rating: Int = 0
    dynamic var title: String = ""
    dynamic var message: String = ""
    dynamic var author: String = ""
    dynamic var date: NSDate = NSDate()
    dynamic var languageCode: String = "en"
    dynamic var travelerTypeRaw: String? {
        didSet {
            if let value = travelerTypeRaw {
                self.travelerType = TravelerType(rawValue: value)
            }
        }
    }

    // MARK: Other Mapped Properties

    var isForeignLanguage: Bool = false
    var travelerType: TravelerType?

    // MARK: Initializers

    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
        self.travelerTypeRaw = self.travelerType?.rawValue
    }

    convenience init(id: Int, rating: Int = 5, title: String = "Title", message: String = "Message", author: String = "Author", foreignLanguage: Bool = false) {
        self.init()
        self.reviewID = id
        self.rating = rating
        self.message = message
        self.title = title
        self.author = author
        self.isForeignLanguage = foreignLanguage
        self.date = NSDate()
        self.travelerTypeRaw = self.travelerType?.rawValue
    }

    // MARK: Realm
    override static func primaryKey() -> String? {
        return "reviewID"
    }
    override class func ignoredProperties() -> [String] {
        return ["isForeignLanguage"]
    }

    // MARK: ObjectMapper 
    
    func mapping(map: Map) {
        reviewID <- map["review_id"]
        rating <- (map["rating"], RatingTransform())
        title <- map["title"]
        message <- map["message"]
        author <- map["author"]
        isForeignLanguage <- map["foreignLanguage"]
        date <- (map["date"], GetYourGuideDateTransform())
        languageCode <- map["languageCode"]
        travelerType <- (map["traveler_type"], TravelerTypeTransform())
    }

    // MARK: Hashable 

    override var hashValue: Int {
        return self.reviewID.hashValue
    }
}
