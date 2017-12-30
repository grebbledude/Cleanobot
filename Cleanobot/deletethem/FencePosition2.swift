//
//  FencePosition2.swift
//  Cleanobot
//
//  Created by Pete Bennett on 16/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class FencePosition2 {
    var mFence: Fence2?
 //   var mAdjacent: [Direction: BoardSquare] = [:]
    var fenceClass: FenceObject {
        get {return mFence!.fenceClass }
    }
    var fence: Fence2 {
        get { return mFence!}
        
    }
    init(type: FenceObject) {
//        mAdjacent = directions
        mFence = Fence2.getFence(object: type, position: self)

  
        
    }
    init () {
        
    }

    func getType() -> FenceType {
        return mFence!.type
    }

    

    func display() {

    }
}

