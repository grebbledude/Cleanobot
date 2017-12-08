//
//  RoomTable.swift
//  testsql
//
//  Created by Pete Bennett on 19/11/2016.
//  Copyright © 2016 Pete Bennett. All rights reserved.
//


import SQLite

final class RoomTable: TableHelper {
    public static var TABLE_ROOM = "RoomTable"
    public static let C_ID = "ro_id"
    public static let C_FLOOR = "ro_floor"
    public static let C_ROOM = "ro_room"
    public static let C_HEALTH = "ro_health"
    public static let C_CAPACITY = "ro_capacity"
    public static let C_HAPPINESS = "ro_happiness"
    
    
    private static let table = Table(TABLE_ROOM)
    
    public static let ID = Expression<String>(C_ID)
    public static let FLOOR = Expression<Int>(C_FLOOR)
    public static let ROOM = Expression<Int>(C_ROOM)
    public static let HEALTH = Expression<Int>(C_HEALTH)
    public static let CAPACITY = Expression<Int>(C_CAPACITY)
    public static let HAPPINESS = Expression<Int>(C_HAPPINESS)
    

    
    
    public var id: String!
    public var floor, health, room, capacity, happiness: Int!

    
    init() {
        
        
    }
    init (row: Row) {
        getData(row: row)
    }
    private func getData(row: Row){
        self.id = try! row.get(type(of: self).ID)
        self.floor = try! row.get(type(of: self).FLOOR)
        self.room = try! row.get(type(of: self).ROOM)
        self.health = try! row.get(type(of: self).HEALTH)
        self.capacity = try! row.get(type(of: self).CAPACITY)
        self.happiness = try! row.get(type(of: self).HAPPINESS)
    }
    public static func getKey(db: DBTables, id: String) -> RoomTable? {
        if let row = try! db.con().pluck( table.filter(ID == id)){
            return RoomTable(row: row)
        }
        
        return nil
    }
    public static func getAll(db: DBTables) -> [RoomTable] {
        var result = [RoomTable]()
        for row in try! db.con().prepare(table) {
            result.append(RoomTable(row: row))
        }
        
        return result
    }
    public func insert(db: DBTables) -> Bool{
        
        do{
            let _ = try db.con().run(type(of: self).table.insert(type(of: self).ID <- id,
                                                                 type(of: self).FLOOR <- floor,
                                                                 type(of: self).ROOM <- room,
                                                                 type(of: self).HEALTH <- health,
                                                                 type(of: self).CAPACITY <- capacity,
                                                                 type(of: self).HAPPINESS <- happiness))
        }
        catch { return false }
        return true
    }
    public func delete(db:DBTables){
        let _ = try! db.con().run(type(of: self).table.filter(type(of: self).ID == id).delete())
    }
    public func update (db: DBTables){
        let _ = try! db.con().run(type(of: self).table.filter(type(of: self).ID == id).update(  type(of: self).FLOOR <- floor,
                                                                                              type(of: self).ROOM <- room,
                                                                                              type(of: self).HEALTH <- health,
                                                                                              type(of: self).CAPACITY <- capacity,
                                                                                              type(of: self).HAPPINESS <- happiness))
    }
    public static func create(db: DBTables){
        let _ = try! db.con().run ( table.create{ t in
            t.column(ID, primaryKey: true)
            t.column(FLOOR)
            t.column(ROOM)
            t.column(HEALTH)
            t.column(CAPACITY)
            t.column(HAPPINESS)
            
        })
    }
    public static func drop(db: DBTables){
        let _ = try! db.con().run ( table.drop())
    }
    //    public static func testit (db: DBTables,callback: (_: Expression<Any>,_: Expression<Any>) -> Void){
    //        let stmt = try! db.run(table.filter(callback(c_id,c_email)))
    //    }
    public static func get (db: DBTables, filter: Expression<Bool>) -> [RoomTable]{
        var result = [RoomTable]()
        for row in try! db.con().prepare(table.filter(filter)) {
            result.append(RoomTable(row: row))
        }
        return result
    }
    public static func get(db: DBTables, filter: Expression<Bool>, orderby: [Expressible]) -> [RoomTable]{
        if orderby.count == 0 {
            return RoomTable.get(db: db, filter: filter)
        }
        var sortOrder = orderby
        for _ in 0...3 {
            sortOrder.append(orderby[0])
        }
        var result = [RoomTable]()
        for row in try! db.con().prepare(table.filter(filter).order(sortOrder[0],sortOrder[1],sortOrder[2],sortOrder[3],sortOrder[4])) {
            result.append(RoomTable(row: row))
        }
        return result
    }

}

