//
//  TurnsXML.swift
//  Robots
//
//  Created by Pete Bennett on 28/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
import AEXML
class TurnsXML {
    static func write(turns: [[Action]], floor: Int, room: Int) {
        let document = AEXMLDocument()
        let attributes = ["floor" : String(floor), "room" : String(room), "instructables" : String(turns[0].count), "turns": String (turns.count)]
        
        let header = document.addChild(name: "turns", value: "", attributes: attributes)
        for i in 0...turns[0].count - 1 {
            let robot = header.addChild(name: "instructable")
            for j in 0...turns.count - 1 {
                robot.addChild(name: "action", value: String(turns[j][i].rawValue), attributes: [:])
            }
        }
   //     print(document.xml)
        let file = "turns.\(String(floor)).\(String(room)).xml" //this is the file. we will write to and read from it
        
        do {
            
            let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory!.appendingPathComponent(file)
            try document.xml.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
    
                print (error.localizedDescription)/* error handling here */
        }
    }



    static func read(floor: Int, room: Int) -> [[Action]]?{
        let file = "turns.\(String(floor)).\(String(room)).xml" //this is the file. we will write to and read from it
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(file)
            
            let data = try Data(contentsOf:  fileURL)
            
            let xmlDoc = try AEXMLDocument(xml: data, options: AEXMLOptions())
            
            let attrs  = xmlDoc.root.attributes
//            let robotCount = Int(attrs["instructables"]!)!
            let turnCount = Int(attrs["turns"]!)!
            var actions: [[Action]] = Array.init(repeating: [], count: turnCount)

            for instructable in xmlDoc.root.children {
                //  Must be an instructable
                var turn = 0
                for action in instructable.children {
                    actions[turn].append(Action(rawValue: Int(action.value!)!)!)
                    turn += 1
                }
            }
            
            return actions
        } catch let error {
            
            print (error.localizedDescription)/* error handling here */
            return nil
        }
    }

}



