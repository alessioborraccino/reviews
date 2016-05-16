//
//  Transforms.swift
//  reviews
//
//  Created by Alessio Borraccino on 16/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import ObjectMapper


struct DateFormatter {

    static private let dateFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()

    static func dateFromGetYourGuideString(dateString: String) -> NSDate {
        return dateFormatter.dateFromString(dateString)!
    }
    static func getYourGuideStringFromDate(date : NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
}


class GetYourGuideDateTransform :TransformType {
    func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateString = value as? String {
            return DateFormatter.dateFromGetYourGuideString(dateString)
        }
        return NSDate()
    }
    func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            return DateFormatter.getYourGuideStringFromDate(date)
        }
        return nil
    }
}
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


