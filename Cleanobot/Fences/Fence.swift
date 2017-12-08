//
//  Fence.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
enum FenceObject: String {
    case normal
    case electric
    case none
    case door
    
}
class Fence {
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
    static func getFence (object: FenceObject, position: FencePosition, doorStatus: FenceDoor.DoorStatus = .closed) -> Fence {
        switch object {
        case .normal:
            return FenceNormal()
        case .electric:
            return FenceElectric()
        case .none:
            return Fence()
        case .door:
            return FenceDoor(status: doorStatus, position: position)
            
        }
    }
}


