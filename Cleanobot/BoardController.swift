//
//  ViewController.swift
//  Robots
//
//  Created by Pete Bennett on 11/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class BoardController: UIViewController {
    


    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var boardStack: UIView!



 
    weak var mPlayController: PlayDelegate?

    var mCounts: [Int] = []
    var mOrigIndexPath: IndexPath?  // ????
    var mBoard: Board?
    var mTotalTurns = C.TOTAL_TURNS
    
    
    //var mFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

  
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        printFrames(view, 0)
        mBoard?.removeConstraints()
    }


    func getNewBoard() -> Board {


        mBoard = Board(controller: self)
        return mBoard!
    }
    //MARK: Callbacks from board
    func setInstructable(index: Int, image: String) {  // Just pass on
        mPlayController?.setInstructable(index: index, image: image)
        
    }
 // Pass through functions
    func finishedTurn() {
        mPlayController?.finishedTurn()
    }
    func nextInstructable(index: Int) {
        mPlayController?.nextInstructable(index: index)

    }
    func reduceHealth(by : Int, cause: CauseOfDeath) {
        mPlayController?.reduceHealth(by: by, cause: cause)
    
    }
    func reduceCapacity(by : Int) {
        
        mPlayController?.reduceCapacity(by: by)
    }
    func reducePower(by: Int) {
        mPlayController?.reducePower(by: by)

    }
    func foundDoor(rubbish: Int) -> Bool {
        return mPlayController!.foundDoor(rubbish: rubbish)

    }
    // Get functions
    func getBoardView(x: Int, y: Int) -> FenceView {
        return boardStack.subviews[x].subviews[y] as! FenceView
    }
    func getBoardStack() -> UIView {
        return boardView
      //  return boardStack!
    }
    func getBoard() -> Board {
        return mBoard!
    }
    func addRobotView(robot: UIView) {
        boardView.addSubview(robot)
    }
    func insertRobotView(robot: UIView) {
        boardView.insertSubview(robot, at: 1)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation */
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     if  segue.identifier == "playSegue" {
     let dest = segue.destination as! BoardController
     //            xxx
     }
     } */
    func passData(source: UIViewController) {
        mPlayController = source as? PlayDelegate
    }
    
}
protocol PlayDelegate: class {
    func setInstructable(index: Int, image: String)
    
    func setTotalTurns(turns: Int)
    func finishedTurn()
    
    func chooseNextAction()
    
    func nextInstructable(index: Int)
    func reduceHealth(by delta: Int, cause: CauseOfDeath)
    func reduceCapacity(by delta: Int)
    func reducePower(by delta: Int) -> Bool
    func reduceHappiness(by delta: Int)
    func getHappiness() -> Int
    func foundDoor(rubbish: Int) -> Bool 

}


