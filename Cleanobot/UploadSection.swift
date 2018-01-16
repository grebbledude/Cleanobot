//
//  UploadSection.swift
//  Cleanobot
//
//  Created by Pete Bennett on 12/01/2018.
//  Copyright © 2018 Pete Bennett. All rights reserved.
//

import Foundation
import Alamofire
import SQLite
import AEXML
import Zip

class UploadSection {
    static let PASSWORD = "dfDFA1532DFCDasdfsd"
    var mComplete = false
    func download() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("board1.png")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download("http://cleanobot.hopto.org/downloadBoard.php", method: .post, parameters: ["time":"1515708926", "type":"board1"], encoding: JSONEncoding.default, headers: nil, to: destination) .response { response in
            print(response)
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                let image = UIImage(contentsOfFile: imagePath)
            } else {
                print (response.error)
            }
            
            //    Alamofire.download("http://cleanobot.hopto.org/downloadBoard.php?time=1515708926&type=board1", to: destination).response(completionHandler: {completionResult in print(completionResult)} ).response { response in
            print(response)
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                let image = UIImage(contentsOfFile: imagePath)
            } else {
                print (response.error)
            }
        }
        
    }
    func upLoadBoards(floor: Int) {
        if !validateFloor (floor: floor) {
            return
        }
        let boardBase = "board.\(floor)."
        let moveBase = "turns.\(floor)."
        let rooms = RoomTable.get(db: DBTables(), filter: RoomTable.FLOOR == floor, orderby: [RoomTable.FLOOR])
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let statsURL = URL(string: "stats.xml", relativeTo: docURL)!
        let document = AEXMLDocument()
        let attributes = ["floor" : String(floor)]
        
        let header = document.addChild(name: "stats", value: "", attributes: attributes)
        for room in rooms {
            let attributes = ["health" : String(room.health), "capacity" : String(room.capacity), "happiness" : String(room.happiness)]
            let _ = header.addChild(name: "room", value: "", attributes: attributes)
        }
        do {
            try document.xml.write(to: statsURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            
            print (error.localizedDescription)/* error handling here */
            return
        }
        let boardURL = Bundle.main.resourceURL!
        let zipURL = URL(fileURLWithPath: "upload.zip", relativeTo: docURL)
        var toZip = [statsURL]
        try? fileManager.removeItem(at: zipURL)
        do
        {
            for i in 1...10 {
                let urlBoard = URL(fileURLWithPath: boardBase + String(i) + ".xml", relativeTo: boardURL)
                let urlMove = URL(fileURLWithPath: moveBase + String(i) + ".xml", relativeTo: docURL)
                let urlTBoard = URL(fileURLWithPath: "board." + String(i) + ".xml", relativeTo: docURL)
                let urlTMove = URL(fileURLWithPath: "turn." + String(i) + ".xml", relativeTo: docURL)
                
                try? fileManager.removeItem(at: urlTBoard)
                try? fileManager.removeItem(at: urlTMove)
                toZip.append(urlTBoard)
                toZip.append(urlTMove)
                try fileManager.copyItem(at: urlBoard, to: urlTBoard)
                try fileManager.copyItem(at: urlMove, to: urlTMove)
            }
        } catch let error {
            print (error.localizedDescription)
            return //  Can't do anything now.
        }

        do {
            try Zip.zipFiles(paths: toZip, zipFilePath: zipURL, password: UploadSection.PASSWORD, progress: { (progress) -> () in
                if (progress == 1.0) && !self.mComplete {
                    self.mComplete = true  // only do this once, and delay long enough for it to complete
                    let when = DispatchTime.now() + 0.5
                    DispatchQueue.main.asyncAfter(deadline: when, execute: {
                        self.uploadZip(zipURL: zipURL)
                        })
                }
            })
        } catch let error {
            print (error.localizedDescription)
        }
        return
    }
    func uploadZip (zipURL: URL) {
//    }
//    func xxx(zipURL: URL) {
        
        //        Alamofire.upload(fileURL: url, to: "192.168.0.91")
        //       Alamofire.upload(url, to: "http://192.168.0.91/uploadBoard.php")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append("myvalue".data(using: String.Encoding.utf8)!, withName: "mykey")
                multipartFormData.append(zipURL, withName: "zip" )
   
        },
            to: "http://cleanobot.hopto.org/uploadBoards2.php",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = response.result.value as! [String : Any]
                        print(json)
                        let message = json["message"] as? String
                        if message == "OK" {
                            let key = json["key"] as! String
                            self.uploadOK(key: key)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        unpackFloor(from: zipURL, to: 99)
        /*
        //        Alamofire.upload(fileURL: url, to: "192.168.0.91")
        //       Alamofire.upload(url, to: "http://192.168.0.91/uploadBoard.php")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append("myvalue".data(using: String.Encoding.utf8)!, withName: "mykey")
                multipartFormData.append(statsURL, withName: "stats" )
                for i in 1...10 {
                    let urlBoard = URL(fileURLWithPath: boardBase + String(i) + ".xml", relativeTo: boardURL)
                    let urlMove = URL(fileURLWithPath: moveBase + String(i) + ".xml", relativeTo: docURL)
                    
                    multipartFormData.append(urlBoard, withName: "board" + String(i))
                    multipartFormData.append(urlMove, withName: "move" + String(i))
                }
        },
            to: "http://cleanobot.hopto.org/uploadBoards.php",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = response.result.value as! [String : Any]
                        print(json)
                        let message = json["message"] as? String
                        if message == "OK" {
                            let key = json["key"] as! String
                            self.uploadOK(key: key)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }) */
    }
    func uploadOK(key: String) {
        print("uploaded with \(key)")
    }
    func validateFloor(floor: Int) -> Bool {
        return true
    }
    func unpackFloor(from zipURL: URL, to floor: Int) {
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let floorURL = URL(fileURLWithPath: "floor", relativeTo: docURL)
        let thisFloorURL = docURL.appendingPathComponent("floor.\(floor)/")

  //      do {
        if fileManager.fileExists(atPath: thisFloorURL.path) {

            try? fileManager.removeItem(atPath: thisFloorURL.path + "/stats.xml")
            for i in 1...10 {
                try? fileManager.removeItem(atPath: thisFloorURL.path + "/board.\(i).xml")
                try? fileManager.removeItem(atPath: thisFloorURL.path + "/hint.\(i).xml")
            }
        }
 
        try? fileManager.createDirectory(at: thisFloorURL, withIntermediateDirectories: false, attributes: nil) //ignore already exist error
        do {
            try Zip.unzipFile(zipURL, destination: floorURL, overwrite: true, password: UploadSection.PASSWORD, progress: nil, fileOutputHandler: {( file ) in
                let fName = file.lastPathComponent
                let typeRange = fName.startIndex..<fName.index(fName.startIndex, offsetBy: 4)
                let type = fName[typeRange]
                var targetString = fName
                if type == "turn" {
                    let numRange = fName.index(fName.startIndex, offsetBy: 5)..<fName.endIndex
                    let num = fName[numRange]
                    targetString = "hint.\(num)"
                }
                let targetURL = thisFloorURL.appendingPathComponent(targetString)
   
                if fileManager.fileExists(atPath: targetURL.path) {
                    try! fileManager.removeItem(at: targetURL)
                }
        })
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
