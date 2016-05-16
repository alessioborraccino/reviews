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

    private(set) dynamic var reviewID : Int = 0
    private(set) dynamic var rating: Int = 0
    private(set) dynamic var title: String = ""
    private(set) dynamic var message: String = ""
    private(set) dynamic var author: String = ""
    private(set) dynamic var date: NSDate = NSDate()
    private(set) dynamic var languageCode: String = "en"
    private(set) dynamic var travelerTypeRaw: String? {
        didSet {
            if let value = travelerTypeRaw {
                self.travelerType = TravelerType(rawValue: value)
            }
        }
    }

    // MARK: Other Mapped Properties

    private(set) var isForeignLanguage: Bool = false
    private(set) var travelerType: TravelerType?

    // MARK: Initializers

    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
        self.travelerTypeRaw = self.travelerType?.rawValue
    }

    convenience init(id: Int,
                     rating: Int = 5,
                     title: String = "Title",
                     message: String = "Message",
                     author: String = "Author",
                     date: NSDate = NSDate(),
                     languageCode: String = NSLocale.preferredLanguageCode(),
                     foreignLanguage: Bool = false) {
        self.init()
        self.reviewID = id
        self.rating = rating
        self.title = title
        self.message = message
        self.author = author
        self.date = NSDate()
        self.languageCode = languageCode
        self.isForeignLanguage = foreignLanguage
        self.travelerTypeRaw = TravelerType.Solo.rawValue
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
        date <- (map["date"], DateTransform())
        languageCode <- map["languageCode"]
        travelerType <- (map["traveler_type"], TravelerTypeTransform())
    }

    // MARK: Helpers

    func hasSameContentAsOtherReview(review: Review) -> Bool {
        return review.reviewID == self.reviewID &&
            review.title == self.title &&
            review.message == self.message &&
            review.rating == self.rating
    }

    // MARK: Hashable 

    override var hashValue: Int {
        return self.reviewID.hashValue
    }
}
