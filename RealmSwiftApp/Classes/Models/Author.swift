//
//  Author.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/28/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import RealmSwift

class Author: Object {
    
    private (set) dynamic var person: Person?
    dynamic var authorId: String?
    let writtenBooks = LinkingObjects(fromType: Book.self, property: "author")
    let followers = LinkingObjects(fromType: Person.self, property: "favoriteAuthors")
    
    
    convenience init(person: Person) {
        self.init()
        self.person = person
        self.authorId = UUID().uuidString
    }
    
    override static func primaryKey() -> String? {
        return "authorId"
    }

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
