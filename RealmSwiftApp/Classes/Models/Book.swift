//
//  Book.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/28/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    dynamic var bookId: String = ""
    dynamic var genre: String = ""
    dynamic var title: String = ""
    dynamic var pages: Double = 0
    dynamic var price: Double = 0
    dynamic var author: Author?
    
    let readers = List<Person>()
    
    
    override static func primaryKey() -> String {
        return "bookId"
    }
    
    
    func addReader(_ reader: Person) {
        let realm = RealmDbManager.shared.realm
        
        let contains = self.readers.filter("id = %@", reader.id)
        if contains.count != 1 {
            try! realm.write {
                self.readers.append(reader)
            }
            reader.addReadBook(self)
        }
    }
    
//    func addReaders(_ readers: [Person]) {
//        let realm = RealmDbManager.shared.realm
//        
//        try! realm.write {
//            self.readers.append(objectsIn: readers)
//        }
//    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
