//
//  HelpPlayController.swift
//  Robots
//
//  Created by Pete Bennett on 09/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

@IBDesignable class HelpPlayController: UIViewController, PlayDelegate {
    var mBoardController: SmallBoardController?
    var mRobot: String?
    var mVisible = false
    @IBInspectable var robot: String {
        get {
            if let rob = mRobot {
                return rob
            }
            return "none"
        }
        set (newValue) {
            mRobot = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        let board = mBoardController!.getNewBoard()
        let position = board.getSquare(x: 0, y: 0)
        switch robot {
        case "sweeper":
            
            let sweeper = SweeperRobot(position: position, direction: .right, board: board)
            board.addHouseRobot(robot: sweeper)
        default:
            break
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mVisible = true
        
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.doMove()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mVisible = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doMove() {
        if mVisible {
            mBoardController?.getBoard().doHouse(index: 0)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "board" {
            mBoardController = segue.destination as? SmallBoardController
            mBoardController!.passData(source: self)
        }
        
        
    }

    func setInstructable(index: Int, image: String){
        
    }
    
    func setTotalTurns(turns: Int){
        
    }
    func finishedTurn(){
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.doMove()
        }
    }
    
    func chooseNextAction(){
        
    }
    
    func nextInstructable(index: Int){
        
    }
    func reduceHealth(by delta: Int, cause: CauseOfDeath){
        
    }
    func reduceCapacity(by delta: Int){
        
    }
    func reducePower(by delta: Int) -> Bool {
        return true
    }
    func reduceHappiness(by delta: Int) {
        
    }
    func getHappiness() -> Int {
        return 0
    }
    func foundDoor(rubbish: Int) -> Bool {
        return true
    }

}
