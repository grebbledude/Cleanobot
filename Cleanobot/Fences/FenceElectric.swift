//
//  FenceElectric.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class FenceElectric: Fence {
    override  var type: FenceType {
        return .electrified
    }
    
    override var fenceClass: FenceObject {
        get {return .electric}
    }
    override  var image: UIImage {
        get {
            return UIImage(named: "electricImage")!
        }
    }
}
