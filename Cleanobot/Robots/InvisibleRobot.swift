//
//  InvisibleRobot.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class InvisibleRobot: Robot {
    override func getImageView(frame: CGRect) -> UIImageView {
        // Override to provide an animated subclass
        let view = UIImageView(frame: frame)

        return view
    }
}
