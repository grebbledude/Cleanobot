//
//  XMLCrawler.swift
//  Robots
//
//  Created by Pete Bennett on 20/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
import AEXML
class XMLCrawler: Robot {
    override func createView() {
        //  No viw for the crawler
    }
    override func animateMove(from: BoardSquare, to: BoardSquare) {
        // no animation of non existent view
    }
    override func canInteract(inSquare target: BoardSquare) -> Bool {
        return true
    }
    override func animateTurn(_ delta: Float, fastTurn: Bool = false) {
        // And do nothing again
    }
    
    override func canMove(fence: FenceType) -> Bool {  //ignore fences
        switch fence {
        case .edge:
            return false
            
        default:
            return true
        }
    }
    override func interact(with robot: Robot) -> Bool {
        // and ignore other robots
        return true
    }
    static func writeXML(board: Board, floor: Int, room: Int, instructions: [Int]) {
        let crawler = XMLCrawler(position: board.getSquare(x: 0, y: 0), direction: .right, board: board)
        let document = AEXMLDocument()
        let attributes = ["floor" : String(floor), "room" : String(room), "count0" : String(instructions[0]), "count1": String(instructions[1]), "count2": String(instructions[2])]

        let header = document.addChild(name: "board", value: "The sleeping quarters", attributes: attributes)
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        crawler.turnXML(header: header, direction: .right)
        crawler.moveXML(header: header)
        crawler.turnXML(header: header, direction: .right)
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        crawler.turnXML(header: header, direction: .left)
        crawler.moveXML(header: header)
        crawler.turnXML(header: header, direction: .left)
        
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        crawler.turnXML(header: header, direction: .right)
        crawler.moveXML(header: header)
        crawler.turnXML(header: header, direction: .right)
        
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        crawler.turnXML(header: header, direction: .left)
        crawler.moveXML(header: header)
        crawler.turnXML(header: header, direction: .left)
        
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        crawler.turnXML(header: header, direction: .right)
        crawler.moveXML(header: header)
        crawler.turnXML(header: header, direction: .right)
        
        for _ in 0...4 {
            crawler.moveXML(header: header)
        }
        
        print(document.xml)
        let file = "board.\(String(floor)).\(String(room)).xml" //this is the file. we will write to and read from it
        

        if let dir = Bundle.main.resourceURL {
            
            let path = dir.appendingPathComponent(file)
 
            //writing
            do {
                try document.xml.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch let error {
                print (error.localizedDescription)/* error handling here */}
        }
    }
    func moveXML(header: AEXMLElement) {
        doMove()
        let move = header.addChild(name: "move")
        for dir: Direction in [.left, .right, .up, .down] {
            if let fencePos = mPosition.getFence(in: dir) {
                if fencePos.fenceClass != .none {
                    if let door = fencePos.fence as? FenceDoor {
                        
                        move.addChild(name: "fence", value: nil, attributes: ["direction":dir.rawValue,"type": fencePos.fenceClass.rawValue,"doorStatus": door.status.rawValue])
                    } else {
                        move.addChild(name: "fence", value: nil, attributes: ["direction":dir.rawValue,"type": fencePos.fenceClass.rawValue])
                    }
                }
            }
        }
        for robot in mPosition.getContent() {
            switch robot {
            case let rub as RubbishRobot:
                move.addChild(name: C.RUBBISH, value: nil, attributes: [C.VOLUME : String(rub.getVolume())])
            case _ as OokRobot:
                move.addChild(name: C.OOK, value: nil, attributes: ["direction": robot.direction.rawValue])
            case _ as LaundryRobot:
                move.addChild(name: C.LAUNDRY, value: nil, attributes: ["direction": robot.direction.rawValue])
            case _ as SweeperRobot:
                move.addChild(name: C.SWEEPER, value: nil, attributes: ["direction": robot.direction.rawValue])
            case _ as MouseRobot:
                move.addChild(name: C.MOUSE, value: nil, attributes: ["direction": robot.direction.rawValue])
            default:
                break
            }
        }
 

        
    }
    func turnXML(header: AEXMLElement, direction: Direction) {
        header.addChild(name: "turn", value: direction.rawValue, attributes: [:])
        if direction == .left {
            _ = turnLeft()
        } else {
            _ = turnRight()
        }
        
    }
    static func readXML(board: Board, floor: Int, room: Int) -> [Int]{
        
        let crawler = XMLCrawler(position: board.getSquare(x: 0, y: 0), direction: .right, board: board)
        
        let dir = Bundle.main.resourceURL!
        
        let name = "board." + String(floor) + "." + String(room)+".xml"
        let url = dir.appendingPathComponent(name)
 //       let url = URL(fileURLWithPath: file)
   //     let xmlPath = Bundle.main.url(forResource: name, withExtension: "xml")
        let data = try! Data(contentsOf:  url)

        let xmlDoc = try! AEXMLDocument(xml: data, options: AEXMLOptions())

        let attrs  = xmlDoc.root.attributes
        let count = [Int(attrs["count0"]!)!, Int(attrs["count1"]!)!, Int(attrs["count2"]!)!]
        if let final = attrs["final"] {
            board.finalSection = Bool(final)!
        }
        if let maxStoryS = attrs[C.MAXPAGE] {
            let maxStory = Int(maxStoryS)!
            board.maxStory = maxStory
        }
            // prints cats, dogs
        for child in xmlDoc.root.children {
            if child.name == "move" {
                crawler.doMove()
                for grandchild in child.children {
                    switch grandchild.name {
                    case "fence":
                        let direction = Direction(rawValue: grandchild.attributes["direction"]!)!
                        let type = FenceObject(rawValue: grandchild.attributes["type"]!)!
                        let fencePos = crawler.getPosition().getFence(in: direction)!
                        if type == .door {
                            let status = grandchild.attributes["doorStatus"] ?? "closed"
                            
                            fencePos.setFenceType(type: type, doorStatus: FenceDoor.DoorStatus(rawValue: status)!)
                            board.addDoor(door: fencePos.fence as! FenceDoor)
                        } else {
                            fencePos.setFenceType(type: type)
                        }
                    case C.RUBBISH:
                        let rub = RubbishRobot(position: crawler.getPosition(), direction: .right, board: board)
                        board.addHouseRobot(robot: rub)
                        rub.setVolume(volume: Int(grandchild.attributes[C.VOLUME]!)!)
                    case C.LAUNDRY:
                        let direction = Direction(rawValue: grandchild.attributes["direction"]!)!
                        let laundry = LaundryRobot(position: crawler.getPosition(), direction: direction, board: board)
                        board.addHouseRobot(robot: laundry)
                    case C.SWEEPER:
                        let direction = Direction(rawValue: grandchild.attributes["direction"]!)!
                        let sweeper = SweeperRobot(position: crawler.getPosition(), direction: direction, board: board)
                        board.addHouseRobot(robot: sweeper)
                    case C.MOUSE:
                        let direction = Direction(rawValue: grandchild.attributes["direction"]!)!
                        let mouse = board.createMouse(position: crawler.getPosition(), direction: direction)
                        board.addInstructable(robot: mouse)
                    case C.OOK:
                        let ook = OokRobot(position: crawler.getPosition(), direction: .right, board: board)
                        board.addHouseRobot(robot: ook)
                    default:
                        break
                    }
                }
            } else {
                // Must be a turn
                let direction = Direction(rawValue: child.value!)!
                if direction == .right {
                    _ = crawler.turnRight()
                } else {
                    _ = crawler.turnLeft()
                }
                
            }
        }
        crawler.destroy(cause: .damage)  //irrelevant cause
        return count
    }

    
    
}
