//
//  EntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RealmSwift

protocol EntityManagerType : RealmManagerType {

    associatedtype EntityType : Object

    func all() -> [EntityType]
    func saveContentsOf(entities: [EntityType]) throws
}

extension EntityManagerType {

    func all() -> [EntityType] {
        return Array(realm.objects(EntityType))
    }

    func saveContentsOf(entities: [EntityType]) throws {
        let canUpdate = EntityType.primaryKey() != nil
        try writeToRealm {
            realm.add(entities, update: canUpdate)
        }
    }

    private func writeToRealm(@noescape realmTransaction: () -> ()) throws {

        if realm.inWriteTransaction {
            realmTransaction()
        } else {
            do {
                try realm.write {
                    realmTransaction()
                }
                return
            } catch let error {
                throw error
            }
        }
    }
}
