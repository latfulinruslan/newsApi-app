//
//  StorageManager.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/29/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ object: Article) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func clearDB() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
