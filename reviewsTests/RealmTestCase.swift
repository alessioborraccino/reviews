//
//  RealmTestCase.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift

// A base class which each of your Realm-using tests should inherit from rather
// than directly from XCTestCase
// Also tests some logics of MOQueryable
class RealmTestCase: XCTestCase {
  
    var testRealm : Realm = {
        var realmConfiguration = Realm.Configuration()
        realmConfiguration.inMemoryIdentifier = "testRealm"
        return try! Realm(configuration: realmConfiguration)
    }()

    override func setUp() {
        try! testRealm.write {
            testRealm.deleteAll()
        }
    }
}
