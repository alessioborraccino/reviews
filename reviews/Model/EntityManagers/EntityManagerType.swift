//
//  EntityManager.swift
//  reviews
//
//  Created by Alessio Borraccino on 13/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Any class that conforms to this protocol will be able to interact with Realm Database

 - parameters:
   - Class type
 */
protocol EntityManagerType : RealmManagerType {

    associatedtype EntityType : Object

    func all() -> [EntityType]
    func saveContentsOf(entities: [EntityType]) throws
}

extension EntityManagerType {

    /**
     Fetch instances

     - returns:
       - All instances of an entity
     */
    func all() -> [EntityType] {
        return Array(realm.objects(EntityType))
    }

    /**
     Save array of instances

     - parameters: 
       - [EntityType]: Array of entities to save
     - throws:
       - All instances of an entity
     */
    func saveContentsOf(entities: [EntityType]) throws {
        let canUpdate = EntityType.primaryKey() != nil
        try writeToRealm {
            realm.add(entities, update: canUpdate)
        }
    }

    /**
     Uses a write transaction in case is already open or opens a new one in case it is not
     */
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
