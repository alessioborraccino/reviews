//
//  Locale.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

extension NSLocale {

    static func preferredLanguageCode() -> String {
        let locale = NSLocale.preferredLanguages()[0]
        return locale.substringToIndex(locale.startIndex.advancedBy(2))
    }
}