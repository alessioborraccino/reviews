//
//  EntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RealmSwift

protocol RealmManagerType {
    var realm : Realm { get }
}

class RealmManager : RealmManagerType {

    static let defaultRealm : Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch (let error) {
            print(error)
            fatalError("Could not load realm database")
        }
    }()

    let realm: Realm

    init(realm: Realm = RealmManager.defaultRealm) {
        self.realm = realm
    }
}