//
//  Person.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/27/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import RealmSwift



class Person: Object {
    
    dynamic var id: String = ""
    dynamic var firsName: String = ""
    dynamic var lastName: String = ""
    dynamic var birthday: Date?
    private (set) dynamic var rlmGender: Int = 0
    dynamic var pair: Person?
    
    
    let readBooks = List<Book>()
    let favoriteAuthors = List<Author>()
    var name: String? {
        return firsName + " " + lastName
    }
    var gender: Gender? {
        return Gender(rawValue: rlmGender)
    }
    
    
    convenience init(firstName: String,
                     lastName: String,
                     gender: Gender,
                     birthday: Date) {
        self.init()
        self.firsName = firstName
        self.lastName = lastName
        self.rlmGender = gender.rawValue
        self.birthday = birthday
        self.id = UUID().uuidString
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func addInRelationshipWith(_ person: Person?) {
        if rlmGender == person?.rlmGender {
            print("\n~~та ну нах!.. одностатевість не підтримується додатком")
            return
        }
        try! RealmDbManager.shared.realm.write {
            self.pair = person
            person?.pair = self
        }
    }
    
    func addReadBook(_ aBook: Book) {
        let realm = try! Realm()
        
        let containsObjs = self.readBooks.filter("bookId = %@", aBook.bookId)
        if containsObjs.count != 1 {
            try! realm.write {
                self.readBooks.append(aBook)
            }
            aBook.addReader(self)
        }
    }
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return ["rlmGender"]
//  }
}



enum Gender: Int {
    case female, male
    
    func stringValue() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
