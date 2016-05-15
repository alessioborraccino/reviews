//
//  HasClassName.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol HasClassNameType {
    static var className : String { get }
}

extension HasClassNameType {
    static var className : String {
        return String(self)
    }
}

protocol ReusableType : HasClassNameType {
    static var identifierForReuse : String { get }
}
extension ReusableType {
    static var identifierForReuse : String {
        return className
    }
}