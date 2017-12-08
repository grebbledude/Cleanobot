//
//  InstructableRobot.swift
//  Robots
//
//  Created by Pete Bennett on 13/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class InstructableRobot: Robot {
    var mInstructions: Queue<Action>!
    func setInstructions (as turns: [[Action]], for index: Int) {
        mInstructions = Queue()
        for i in 0...(turns.count - 1) {
            mInstructions.enqueue(turns[i][index])
        }
    }
    func moveAfterInstruction() -> Bool  {
    // do instruction and return true if we want to still move
        if let instruction = mInstructions.dequeue() {  // This should always be true
            switch instruction {
            case .right: return turnRight()
            case .left: return turnLeft()
            case .activate: return doActivate()
            case .nop: return doNothing()
            default: return false  // never happens
            }
        }
        return false //  should never get here
    }
    
    override func createsRubbish() -> Int? {
        return 1  // default.  Larger robots may produce more
    }
    func doActivate() -> Bool {  // This will be overridden if there is anything to do
        return false
    }
  }
