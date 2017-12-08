//
//  Debug.swift
//  Robots
//
//  Created by Pete Bennett on 16/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class Debug {
    static     func xprintConstraints(_ count: Int, _ view: UIView) {
        switch view {
        case is UIStackView:
            print (" \(count) is stack View \(view)")
        case is FenceView:
            print(" \(count) is fence view \(view)")
        case is FinishView:
            print(" \(count) is finish view \(view)")
        case is UIImageView:
            print(" \(count) is image view \(view)")
        default:
            print(" \(count) is just view \(view)")
        }
        print (view.constraints.count)
        for constraint in view.constraints {
            if constraint.identifier == "init" {
                print ("got init \(constraint) \(view)")
                view.removeConstraint(constraint)
                
            }
            if constraint.identifier == "topRobot" {
                print ("got left \(constraint)")
            }
            if constraint.identifier == "leftRobot" {
                print ("got left \(constraint)")
            }
        }
 
    }
    static     func qprintAllConstraints(_ count: Int, _ view: UIView) {
        switch view {
        case is UIStackView:
            print (" \(count) is stack View \(view)")
        case is FenceView:
            print(" \(count) is fence view \(view)")
        case is FinishView:
            print(" \(count) is finish view \(view)")
        case is UIImageView:
            print(" \(count) is image view \(view)")
        default:
            print(" \(count) is just view \(view)")
        }
        print (view.constraints.count)
        for constraint in view.constraints {
            if constraint.identifier == "init" {
                print ("got init \(constraint) \(view)")
                
            }
            if constraint.identifier == "topRobot" {
                print ("got left \(constraint)")
            }
            if constraint.identifier == "leftRobot" {
                print ("got left \(constraint)")
            }
        }

    }
    static func aprintConstraintsUp(view: UIView) {
        print ("Constraints \(view) \(view.constraints.count)")
        if let superV = view.superview {
            aprintConstraintsUp(view: superV)
        }
    }
    static func xprintConstraintsUp(view: UIView) {
        let superV = view.superview
        print("constraints")
        for constraint in superV!.constraints {
            print (constraint)
        }
    }
}
