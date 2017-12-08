//
//  RubbishRobot.swift
//  Robots
//
//  Created by Pete Bennett on 20/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class RubbishRobot: Robot {
    var mVolume: Int = 0

    override func canMove(fence: FenceType) -> Bool {
        return false // never moves
    }
    override func getImageString() -> String {  // Always overwritten
        return "rubbishImage"
    }
    override func requiresAnimation() -> Bool {
        // no delay for rubbish
        return false
    }
    func getVolume() -> Int {
        return mVolume
    }
    func setVolume(volume: Int) {
        let firstTime = mVolume == 0
        mVolume = volume
        if !firstTime {
            mView?.layer.sublayers?[0].removeFromSuperlayer()
        }
        if mVolume == 0 {
            self.kill()
        } else {
            let baseSize = mView!.frame.height / 3.0
            let newLayer = CATextLayer()
            newLayer.font = "Helvetica-Bold" as CFTypeRef
            newLayer.fontSize = baseSize
            newLayer.string = String(mVolume)
            newLayer.frame = CGRect(x: 0.0, y: baseSize, width: mView!.frame.width, height: baseSize)
            newLayer.alignmentMode = kCAAlignmentCenter
            newLayer.contentsScale = UIScreen.main.scale
            newLayer.foregroundColor = UIColor.black.cgColor
            mView?.layer.addSublayer(newLayer)
        }

        
    }
}
