//
//  Initialise.swift
//  Robots
//
//  Created by Pete Bennett on 29/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class Initialise {
    static func run() {
        let dbt = DBTables()
        FloorTable.create(db: dbt)
        RoomTable.create(db: dbt)
        //        testData(dbt: dbt)
        let defaults = UserDefaults.standard
 
        defaults.set(10, forKey: "power")
        defaults.set(2, forKey: C.MAXPAGE)
        
    }
    static func testData(dbt : DBTables) {
        let room = RoomTable()
        room.id = "1.1"
        room.floor = 1
        room.room = 1
        room.health = -6
        room.happiness = -4
        room.capacity = -7
        room.insert(db: dbt)
        room.room = 2
        room.id = "1.2"
        room.insert(db: dbt)
        room.room = 3
        room.id = "1.3"
        room.insert(db: dbt)
        room.room = 4
        room.id = "1.4"
        room.insert(db: dbt)
    }
}
