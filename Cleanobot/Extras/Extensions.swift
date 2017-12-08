//
//  Extensions.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
extension UIGestureRecognizer {
    func cancel() {
        self.isEnabled = false
        self.isEnabled = true
    }
}
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
enum Direction: String {
    case left
    case up
    case right
    case down
}
enum FenceType: String {
    case none
    case normal
    case electrified
    case edge
}

enum Action: Int {
    case right = 0
    case left = 1
    case activate = 2
    case nop = -1
    case insert = 3 // only useful for dragging
    case delete = 4 // only useful for dragging
    
}

enum RobotType: Int {
    case clear = 0
    case rubbish = 1
    case laundry = 2
    case sweeper = 3
    case mouse = 4
    case ook = 5
    
}

struct RoomCell {
    var health: Int?
    var capacity: Int?
    var happiness: Int?
}
enum TurnDir : Int {
    case clock = 3
    case anticlock = 1
    case opposite = 2
}
enum CauseOfDeath {
    case damage
    case timeout
    case cleaner
    case survived
    case electrocuted
    case capacityExceeded
}

