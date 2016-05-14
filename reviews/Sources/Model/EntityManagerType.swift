//
//  EntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RealmSwift

public protocol EntityManagerType {

    associatedtype EntityType : Object

    var realm: Realm { get }

    func all() -> [EntityType]

    func saveContentsOf(entities: [EntityType]) throws
    func deleteContentsOf(entities: [EntityType]) throws

}


extension EntityManagerType {

    var realm: Realm {
        return Data.defaultRealm
    }

    func all() -> [EntityType] {
        return Array(queryset())
    }

    /**
     Creates or updates entities in the specified realm.

     - parameter entity: entity to be saved
     */

    func saveContentsOf(entities: [EntityType]) throws {
        let canUpdate = EntityType.primaryKey() != nil
        try realmWriteOperation {
            for entity in entities {
                realm.add(entity, update: canUpdate)
            }
        }
    }

    func deleteContentsOf(entities: [EntityType]) throws {
        try realmWriteOperation {
            for entity in entities {
                realm.delete(entity)
            }
        }
    }
    /**
     Executes given block, wrapping it in `realm.write` only if needed.

     - parameter block: operation to be executed.
     */
    private func realmWriteOperation(@noescape block: () -> ()) throws {
        guard !realm.inWriteTransaction else {
            block()
            return
        }
        do {
            try realm.write {
                block()
            }
            return
        } catch let error {
            throw error
        }
    }

    private func queryset() -> Results<EntityType> {
        return realm.objects(EntityType)
    }
}
