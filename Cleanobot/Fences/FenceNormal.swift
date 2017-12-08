//
//  FenceNormal.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class FenceNormal: Fence {
    override var type: FenceType {
        return .normal
    }
    override var fenceClass: FenceObject {
        get {return .normal}
    }
    override var image: UIImage {
        get {
            return UIImage(named: "fenceImage")!
        }
    }
}
