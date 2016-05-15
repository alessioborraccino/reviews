//
//  NSDate+GYG.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

extension NSDate {

    static private let dateFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()

    static func dateFromGetYourGuideString(dateString: String) -> NSDate {
        return NSDate.dateFormatter.dateFromString(dateString)!
    }
    static func getYourGuideStringFromDate(date : NSDate) -> String {
        return NSDate.dateFormatter.stringFromDate(date)
    }
}
