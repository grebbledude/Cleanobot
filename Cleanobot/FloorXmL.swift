//
//  FloorXmL.swift
//  Cleanobot
//
//  Created by Pete Bennett on 10/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
import AEXML
class FloorXML {
    var mDescription: String
    var title: String {
        get {return mDescription}
    }
    
    
    init(floor: Int){
        
        do {
            let dir = Bundle.main.resourceURL!
            
            let name = "Level." + String(floor) + ".xml"
            let url = dir.appendingPathComponent(name)
      
            
            let data = try Data(contentsOf:  url)
            
            let xmlDoc = try AEXMLDocument(xml: data, options: AEXMLOptions())
            
            let attrs  = xmlDoc.root.attributes

            mDescription = attrs["description"]!
            if  Int(attrs["num"]!)! != floor {
                mDescription = "Invalid level file"
            }

            
            return
        } catch let error {
            
            print (error.localizedDescription)/* error handling here */

            mDescription = "Error"
            return
        }
    }
    
}



