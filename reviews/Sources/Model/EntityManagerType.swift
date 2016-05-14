//
//  EntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

public protocol EntityManagerType {

    associatedtype EntityType : Object

    var realm: Realm { get }

    func all() -> [EntityType]
    func save(entity: EntityType) -> Bool
    func saveContentsOf(entities: [EntityType]) -> Bool
}


extension EntityManagerType {

    var realm: Realm {
        return Data.defaultRealm
    }

    func all() -> [EntityType] {
        return Array(queryset())
    }

    /**
     Creates or updates entity in the specified realm.

     - parameter entity: entity to be saved
     - returns: true if operation succeeded; false otherwise.
     */
    func save(entity: EntityType) -> Bool {
        let update = EntityType.primaryKey() != nil
        return realmWriteOperation { realm.add(entity, update: update) }
    }
    public func saveContentsOf(entities: [EntityType]) -> Bool {
        let update = EntityType.primaryKey() != nil
        return realmWriteOperation {
            for entity in entities {
                realm.add(entity, update: update)
            }
        }
    }

    /**
     Executes given block, wrapping it in `realm.write` only if needed.

     - parameter block: operation to be executed.
     - returns: true if operation succeeded; false otherwise.
     */
    private func realmWriteOperation(@noescape block: () -> ()) -> Bool {
        guard !realm.inWriteTransaction else {
            block()
            return true
        }
        do {
            try realm.write {
                block()
            }
            return true
        } catch {
            return false
        }
    }

    private func queryset() -> Results<EntityType> {
        return realm.objects(EntityType)
    }
}
