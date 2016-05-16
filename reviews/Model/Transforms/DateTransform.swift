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


class DateTransform :TransformType {
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




