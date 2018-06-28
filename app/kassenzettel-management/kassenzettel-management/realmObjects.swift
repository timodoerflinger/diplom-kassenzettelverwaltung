//
//  realmObjects.swift
//  kassenzettel-management
//
//  Created by Timo on 20.06.18.
//  Copyright © 2018 Timo. All rights reserved.
//

import Foundation
import RealmSwift

//https://realm.io/docs/swift/latest#models


// kassenzettel model
class kassenzettel: Object {
    @objc dynamic var kassenzettelID = 0
    @objc dynamic var kassenzettelBildname = ""
    @objc dynamic var kassenzettelErfassdatum = ""
    @objc dynamic var kassenzettelAusgelesenerText = ""
    @objc dynamic var kassenzettelEndbetrag = 0.0
    //One-to-many Relationship
        //@objc dynamic var kategorie: kategorie?
    //PrimaryKey überschreiben
    func primaryKey() -> Int? {
        return kassenzettelID
    }
    /*override static func primaryKey() -> String? {
        return "kassenzettelID"
    }*/
    //auto-increment:
    //https://academy.realm.io/posts/realm-primary-keys-tutorial/
    //https://stackoverflow.com/questions/39579025/auto-increment-id-in-realm-swift-3-0
}

// kategorie model
class kategorie: Object {
    @objc dynamic var kategorieID = 0
    @objc dynamic var kategorieName = ""
    //PrimaryKey überschreiben
    func primaryKey() -> Int? {
        return kategorieID
    }
}

