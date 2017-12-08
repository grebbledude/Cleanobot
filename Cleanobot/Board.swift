//
//  Board.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class Board {
    
    private var mSquares: [[BoardSquare]] = []
    private var mRobots: [Robot] = []
    private var mInstructables: [InstructableRobot] = []
    private var mDoors: [FenceDoor] = []
    private weak var mController: BoardController?
    private var mSpeed = 0.4
    private var mPostActivities: [()-> Void] = []
    private var mMaxStory = 0
    private var mFinalSection = false
    private var mMouseCount = 0
    var finalSection: Bool {
        set {mFinalSection = newValue}
        get {return mFinalSection}
    }
    var maxStory: Int {
        set {mMaxStory = newValue}
        get {return mMaxStory}
    }
    init(controller: BoardController, width: Int  = 6, height: Int = 6) {
        mController = controller
        for i in 0...width - 1 {
            var row: [BoardSquare] = []
            for j in 0...height - 1 {
                row.append(BoardSquare(x: i, y: j, board: self ))
            }
            mSquares.append(row)
        }
        // All squares have been created
        if height > 1 {
            for i in 0...width - 1 {
                for j in 0...height - 2 {
                    let _ = FencePosition(type: .none, directions: [.down: mSquares[i][j+1], .up: mSquares[i][j]])
                }
            }
        }
        if width > 1 {
            for i in 0...height - 1  {
                for j in 0...width - 2 {
                    let _ = FencePosition(type: .none, directions: [.right: mSquares[j+1][i], .left: mSquares[j][i]])
                }
            }
        }
        //  Default fences all created
    }
    deinit {
        cleanup()
    }
    func cleanup() {
        for robot in mRobots {
            robot.cleanup()
        }
        for robot in mInstructables {
            robot.cleanup()
        }
        for row in mSquares {
            for square in row {
                square.cleanup()
            }
        }
    }
    func getController() -> BoardController {
        return mController!
    }
    func getSquare( x: Int, y: Int) -> BoardSquare {
        return mSquares[x][y]
    }
    func setup() {
        addInstructable(robot: Cleanomat(position: getSquare(x: 0, y: 0), direction: .right, board: self))
        if mFinalSection {
            addHouseRobot(robot: PowerSwitchRobot(position: getSquare(x: 5, y: 5), direction: .right, board: self))
        } else {
            addHouseRobot(robot: ExitRobot(position: getSquare(x: 5, y: 5), direction: .right, board: self))
        }
        
        // For all bboards
        for i in 0...mInstructables.count - 1 {
            mController!.setInstructable(index: i, image: mInstructables[i].getIcon())
        }
    }
    func createMouse(position: BoardSquare, direction: Direction) ->MouseRobot {
        mMouseCount += 1
        switch (mMouseCount - 1) {
        case 0:
             return MouseRobot(position: position, direction: direction, board: self)
        case 1:
            return GreenMouseRobot(position: position, direction: direction, board: self)
        default:
            fatalError()
        }
    }
    func addInstructable (robot: InstructableRobot) {
        mInstructables.insert(robot, at: 0)
    }
    func addHouseRobot (robot: Robot) {
        mRobots.append(robot)
    }
    func initaliseActions(turns: [[Action]]) {
        for i in 0 ... mInstructables.count - 1 {
            mInstructables[i].setInstructions(as: turns, for: i)
        }
    }
    func doTurn() {
        mPostActivities = []
        self.doInstructable(index: 0)

    }
    func doInstructable(index: Int) {
        mController?.nextInstructable(index: index)
        if index >= mInstructables.count {
            doHouse(index: 0)
        } else {
            mInstructables[index].doMove()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.doInstructable(index: index + 1)
            }
        }
    }
    func doHouse(index: Int) {
        if index >= mRobots.count {
            for door in mDoors {
                mPostActivities.append(door.cycleStatus)
            }
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.doPostActivities(index: 0)
            }
        } else {
            mRobots[index].doMove()
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.doHouse(index: index + 1)
            }
        }
    }
    func doPostActivities (index: Int) {
        if index >= mPostActivities.count  {
            mController!.finishedTurn()
        } else {
            let function = mPostActivities[index]
            function()
            
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.doPostActivities(index: index + 1)
            }
        }
    }
    func layoutRobots() {
        for robot in mInstructables {
            robot.layout()
        }
        for robot in mRobots {
            robot.layout()
        }
    }
    func removeConstraints() {
        for robot in mInstructables {
            robot.resetConstraints()
        }
        for robot in mRobots {
            robot.resetConstraints()
        }
    }
    func constrainRobotLayouts() {
        for robot in mInstructables {
            robot.layoutWithConstraint()
        }
        for robot in mRobots {
            robot.layoutWithConstraint()
        }
    }
    func getSpeed() -> Double {
        return mSpeed
    }
    func setSpeed(to newSpeed: Double)  {
        mSpeed = newSpeed
    }
    func removeRobot(_ robot: Robot) {
        mRobots = mRobots.filter {$0 !== robot}
        // If it is instructable we will simply replace with a dummy entry
        if let inst = robot as? InstructableRobot {
            for i in 0...mInstructables.count - 1 {
                if mInstructables[i] === inst {
                    let deadRobot = DeadInstructable(position: getSquare(x: 0, y: 0), direction: .right, board: self)
                    mInstructables[i] = deadRobot
                    break
                }
            }
        }
    }
    func countRubbish() -> Int {
        var count = 0
        for rub in mRobots where rub is RubbishRobot  {
            let rubbish = rub as! RubbishRobot
            count += rubbish.getVolume()
        }
        return count
    }
    func addDoor(door: FenceDoor) {
        mDoors.append(door)
    }

    
}
