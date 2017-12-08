//
//  Fence.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class FencePosition {
    var mFence: Fence?
    var mAdjacent: [Direction: BoardSquare] = [:]
    var fenceClass: FenceObject {
        get {return mFence!.fenceClass }
    }
    var fence: Fence {
        get { return mFence!}
    
    }
    init(type: FenceObject, directions: [Direction : BoardSquare]) {
        mAdjacent = directions
        mFence = Fence.getFence(object: type, position: self)
        let twoDirections = Array(directions.keys)
        let squares = Array(directions.values)
        if squares.count == 2 {
            squares[0].setFence(fence: self, in: twoDirections[1])
            squares[1].setFence(fence: self, in: twoDirections[0])  // switch the directions
        }
        
        setFenceType(type: type)
    }
    func getNext(in direction: Direction) -> BoardSquare? {
        return mAdjacent[direction]
    }
    func getType() -> FenceType {
        return mFence!.type
    }
    func setFenceType(type: FenceObject) {
        mFence = Fence.getFence(object: type, position: self)
        display()
    }
    
    func setFenceType(type: FenceObject, doorStatus: FenceDoor.DoorStatus) {
        mFence = Fence.getFence(object: type, position: self, doorStatus: doorStatus)
        display()
    }
    func display() {
        let twoDirections = Array(mAdjacent.keys)
        let squares = Array(mAdjacent.values)
        if squares.count == 2 {
            squares[0].getView().setFence(fence: mFence!, direction: twoDirections[1])
            squares[1].getView().setFence(fence: mFence!, direction: twoDirections[0])
        }
    }
}
