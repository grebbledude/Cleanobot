//
//  Fence2.swift
//  Cleanobot
//
//  Created by Pete Bennett on 16/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class Fence2 {
    var type: FenceType {
        get {return .none}
    }
    
    var fenceClass: FenceObject {
        get {return .none}
    }
    var image: UIImage {
        get {
            return UIImage()
        }
    }
    static func getFence (object: FenceObject, position: FencePosition2, doorStatus: FenceDoor2.DoorStatus = .closed) -> Fence2 {

            return FenceDoor2(status: doorStatus)
            
       
    }
    func setAnimatingImages(for imageView: UIImageView) -> Bool{
        // Only for doors at the moment, but leave flexible
        return false // no animation
    }
}



