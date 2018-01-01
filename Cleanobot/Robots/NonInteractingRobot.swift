//
//  NonInteractingRobot.swift
//  Cleanobot
//
//  Created by Pete Bennett on 31/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class NonInteractingRobot: Robot {
    // Do not block movement or things that are fired.
    override func createsRubbish() -> Int? {
        return nil
    }
}
