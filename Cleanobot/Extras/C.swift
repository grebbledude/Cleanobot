//
//  C.swift
//  Robots
//
//  Created by Pete Bennett on 14/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class C {
    static let ROBOT_TYPES = ["clear","rubbish","laundry","sweeper","ook","soapy","polisher"]
    static let RUBBISH = "rubbish"
    static let LAUNDRY = "laundry"
    static let SWEEPER = "sweeper"
    static let MOUSE = "mouse"
    static let OOK = "ook"
    static let SOAPY = "soapy"
    static let POLISHER = "polisher"
    static let VOLUME = "volume"
    static let DIR_SEQUENCE: [Direction] = [.right, .up, .left, .down, .right, .up, .left, .down]
    static let TOTAL_TURNS = 80
    static let TURN_LENGTH = 0.3
    static let INITIAL_HEALTH = 10
    static let INITIAL_CAPACITY = 20
    static let INITIAL_HAPPINESS = 10
    static let INITIAL_POWER = 20
    static let POWER_REGEN = 3 // Minutes
    static let DIR_TO_INT = ["left" : 0, "up" : 1, "right" : 2, "down" : 3]
    static let INT_TO_DIR:  [Int: Direction] = [ 0 : .left, 1: .up, 2 : .right, 3 : .down ]
    static func turn (direction: Direction, turnDir : TurnDir) -> Direction {
        let dirint = DIR_TO_INT[direction.rawValue]! + turnDir.rawValue
        return INT_TO_DIR[ dirint % 4]!
    }
    static func deltaAngle (from: Direction, to: Direction) -> Float {
        let fromInt = C.DIR_TO_INT[from.rawValue]!
        let toInt = C.DIR_TO_INT[to.rawValue]!
        var diff = toInt - fromInt
        if abs(diff) == 3 {
            diff = -diff / 3
        }
        return Float(diff) * Float.pi / 2
        
        
        
    }
    static let MAXPAGE = "maxpage"
    static let STARTPAGE = "startPage"
    static let STORY_STORYBOARD = "StoryItems"
    static let FLOOR = "floor"
}
enum Direction: String {
    case left
    case up
    case right
    case down
}
enum FenceType: String {
    case none
    case normal
    case electrified
    case edge
}

enum Action: Int {
    case right = 0
    case left = 1
    case activate = 2
    case nop = -1
    case insert = 3 // only useful for dragging
    case delete = 4 // only useful for dragging
    
}

enum RobotType: Int {
    case clear = 0
    case rubbish = 1
    case laundry = 2
    case sweeper = 3
    case mouse = 4
    case ook = 5
    case soapy = 6
    case polisher = 7
    
}

struct RoomCell {
    var health: Int?
    var capacity: Int?
    var happiness: Int?
}
enum TurnDir : Int {
    case clock = 3
    case anticlock = 1
    case opposite = 2
}
enum CauseOfDeath {
    case damage
    case timeout
    case survived
    case electrocuted
    case capacityExceeded
    case laundry
}
