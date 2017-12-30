//
//  PolisherRobot.swift
//  Cleanobot
//
//  Created by Pete Bennett on 29/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

class PolisherRobot: InstructableRobot {
    override func canMove(fence: FenceType) -> Bool {

        switch fence {
        case .edge, .normal:
            animateBump()
            return false
        case .electrified:
            destroy(cause: .electrocuted)
            return false
        case .none:
            return true
        }
    }
    
    override func getIcon() -> String {
        return "PolisherImage" //
    }
    
    override func getImageString() -> String {
        return "PolisherImage"
        
    }
    
    override func doActivate() -> Bool {
        // Create Polished Floor Robot
        // But only if there is no rubbish here
        let rub = mPosition.getContent().filter {$0 is RubbishRobot}
        if rub.count > 0 {
            return true
        }
        
        let pol = PolishedFloorRobot(position: mPosition, direction: .right, board: mBoard!)
        mBoard!.addHouseRobot(robot: pol)
        return true // move forwards after polish
    }
}
