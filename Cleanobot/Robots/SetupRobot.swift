//
//  SetupRobot.swift
//  Robots
//
//  Created by Pete Bennett on 19/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class SetupRobot : Robot, UITextFieldDelegate {
    override func canMove(fence: FenceType) -> Bool {
        switch fence {
        case .edge:
            return false

        default:
            return true
        }
    }
    override func interact(with robot: Robot) -> Bool {
 
        return true
    }
    override func getIcon() -> String {
        return "robotImage" //  This is wrong!!!
    }
    
    override func getImageString() -> String {
        return "blueRight"

    }
    func addRobot(type: RobotType) {
        switch type {
        case .clear:
            for robot in mPosition.getContent() {
                if robot !== self {
                    robot.kill()
                }
            }
        case .rubbish:
            createRubbishRobot()
            
        case .laundry:
            createLaundryRobot()
        
        case .sweeper:
            createSweeperRobot()
        case .mouse:
            createMouse()
        case .ook:
            createOok()
        }
    
    
    }
    func createRubbishRobot()  {
        
        let robot = RubbishRobot(position: mPosition, direction: mDirection, board: mBoard!)

        let alert = UIAlertController(title: "Rubbish", message: "What volume?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "1"
        }
        
        
        alert.textFields![0].delegate = self
        alert.textFields![0].keyboardType = .numberPad
        alert.textFields![0].textAlignment = .center
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            robot.setVolume(volume: Int(textField.text!)!)
        }))
        mBoard!.getController().present(alert, animated: true, completion: nil)
        
        mBoard!.addHouseRobot(robot: robot)
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1 character numeric
        if string == "" {
            textField.text = "1"
            return false
        }
        if string.count > 1 {
            return false
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if string == numberFiltered {
            textField.text = string
        }
        
        return false
    }
    
    func createLaundryRobot()  {

        
        let robot = LaundryRobot(position: mPosition, direction: mDirection, board: mBoard!)
        
        mBoard!.addHouseRobot(robot: robot)
        
    }
    func createSweeperRobot()  {
        
        
        let robot = SweeperRobot(position: mPosition, direction: mDirection, board: mBoard!)
        
        mBoard!.addHouseRobot(robot: robot)
        
    }
    func createMouse()  {
        
        
        let robot = MouseRobot(position: mPosition, direction: mDirection, board: mBoard!)
        
        mBoard!.addHouseRobot(robot: robot)
        
    }
    func createOok()  {
        
        
        let robot = OokRobot(position: mPosition, direction: mDirection, board: mBoard!)
        
        mBoard!.addHouseRobot(robot: robot)
        
    }

}
