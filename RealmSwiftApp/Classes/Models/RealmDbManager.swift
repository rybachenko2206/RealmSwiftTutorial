//
//  RealmDbManager.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/27/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import RealmSwift
import Foundation


class RealmDbManager {
    let realm = try! Realm()
    
    static let shared = RealmDbManager()
    private init() {}
    
    
    // MARK: — Save
    func saveObject(_ obj: Object) {
        try! realm.write {
            realm.add(obj, update: true)
        }
    }
    
    func saveObjects(_ objects: [Object]) {
        try! realm.write {
            realm.add(objects, update: true)
        }
    }
    
    // MARK: — Get
    func getAll<T: Object>(ofType: T.Type) -> Results<T>? {
        return realm.objects(ofType)
    }
    
    // MARK: — Delete
    func delete(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteObjects(_ objects: [Object]) {
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func clearDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
}

