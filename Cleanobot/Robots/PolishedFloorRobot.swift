//
//  PolishedFloorRobot.swift
//  Cleanobot
//
//  Created by Pete Bennett on 28/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class PolishedFloorRobot: Robot {
    override func getImageString() -> String {
        return "polishedImage"
    }
    override func interact(with robot: Robot) -> Bool {
        return true
        
    }
    override func moveAfterAlternativeAction() -> Bool {
        
        return false
        
    }
    override func canMove(fence: FenceType) -> Bool {

        return false
        
        
    }
    override func requiresAnimation() -> Bool {
        // no delay for rubbish, polished floor etc.
        return false
    }
    override func createsRubbish() -> Int? {
        return nil
    }

    

}

