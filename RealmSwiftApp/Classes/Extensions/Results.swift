//
//  Results.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/28/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import RealmSwift
import Realm



extension Results {
    func toArray() -> [T] {
        var array = [T]()
        for obj in self {
            array.append(obj)
        }
        
        return array
    }
    
    func objectAtIndex(_ index: Int) -> T {
        return self[index]
    }
}
