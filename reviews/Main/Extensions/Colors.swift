//
//  Colors.swift
//  reviews
//
//  Created by Alessio Borraccino on 14/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(red: Int, green: Int, blue: Int) {
        precondition(red >= 0 && red <= 255, "Invalid red component")
        precondition(green >= 0 && green <= 255, "Invalid green component")
        precondition(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience public init(white: Int) {
        self.init(white: CGFloat(white) / 255.0, alpha: 1)
    }
}

struct AppColor {
    static let main = UIColor(red: 255, green: 61, blue: 0)
    static let textDark = UIColor(white: 74)
    static let textLight = UIColor(white: 160)
}