//
//  Robot.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class Robot: NSObject {
    var mPosition: BoardSquare
    var mDirection: Direction
    weak var mBoard: Board?
    var mUsingInitialConstraints: Bool?
    weak var mXConstraint: NSLayoutConstraint?
    weak var mYConstraint: NSLayoutConstraint?
    var mView: UIImageView?
    var view : UIImageView {
        get { return mView!}
    }
    var direction: Direction {
        get {return mDirection}
    }
    
    init(position: BoardSquare, direction: Direction, board: Board){
        mPosition = position
        mDirection = direction
        super.init()
        mPosition.addContent(self)
        mBoard = board
        
        createView()
        let delta = C.deltaAngle(from: .right, to: mDirection)
        mView?.transform = CGAffineTransform(rotationAngle: CGFloat( delta))
     
    }
    func cleanup() {
        mView?.removeFromSuperview()
    }
    final func doMove() -> Bool {
        if mUsingInitialConstraints != nil && mUsingInitialConstraints! {
            resetConstraints()
        }
        if let controlledRobot = self as? InstructableRobot {
            if let _ = self as? DeadInstructable {
                return false
            }
            if !controlledRobot.moveAfterInstruction() {  // true means carry on and move
                return requiresAnimation()
            }
        }
        
        if !canMove(fence: mPosition.getFenceType(in: mDirection)) {
            if !moveAfterAlternativeAction() {
                return requiresAnimation()
            }
        }
        var target = mPosition.getNext(in: mDirection)!
        if !canInteract(inSquare: target) {
            if !moveAfterAlternativeAction() {
                return requiresAnimation()
            } // need to recalculate target
            if !canMove(fence: mPosition.getFenceType(in: mDirection)) {
                return requiresAnimation()
            }
            target = mPosition.getNext(in: mDirection)!
            if !canInteract(inSquare: target) {
                return requiresAnimation()
            }
  
        }
        executeMove(toSquare: target)
        return requiresAnimation()
    }
    func requiresAnimation() -> Bool {
        // Override this to prevent a delay after the "doMove" call.  For example rubbish
        return true
    }
    func canInteract(inSquare target: BoardSquare) -> Bool {
        var interactOK = true
        for robot in target.getContent() {
            interactOK = interact(with: robot)  && interactOK
        }
        return interactOK
    }
    // To override
    func getIcon() -> String {
        return ""
    }
    func executeMove(toSquare target: BoardSquare) {
        mPosition.removeContent(self)
        
        target.addContent(self)
        animateMove(from: mPosition, to: target)
        mPosition = target
        
    }
    func canMove(fence: FenceType) -> Bool {  // to be overwritten by subclasses
        if fence == .none {
            return true
        } else {
            return false
        }
    }
    //MARK: Interaction
    func interact (with: Robot) -> Bool {  // This must be overwritten.
        return true
    }
    func turnRight() -> Bool {
        mDirection = {
            switch mDirection {
            case .left: return .up
            case .right: return .down
            case .up: return .right
            case .down: return.left
            }
        }()

        
        animateTurn(Float.pi/2)
        return false
    }
    func turnLeft() -> Bool {
        mDirection = {
            switch mDirection {
            case .left: return .down
            case .right: return .up
            case .up: return .left
            case .down: return.right
            }
        }()
        animateTurn(-Float.pi/2)
        return false
    }
    func animateTurn(_ delta: Float, fastTurn: Bool = false) {
        let speed = fastTurn ? (mBoard!.getSpeed() / 4.0) : mBoard!.getSpeed()
        let radians = atan2f(Float(mView!.transform.b), Float(mView!.transform.a));
        UIView.animate(withDuration: speed, animations: {
            self.mView!.transform = CGAffineTransform(rotationAngle: CGFloat(radians + delta))
        })
    }

    func doNothing() -> Bool {
        return true
    }
    func createView() {
        mView = getImageView(frame: mPosition.getView().frame)
        if let _ = self as? RubbishRobot {
            mBoard!.getController().insertRobotView(robot: mView!)
        } else {
            mBoard!.getController().addRobotView(robot: mView!)
        }
        layout()
    }
    func getImageView(frame: CGRect) -> UIImageView {
        // Override to provide an animated subclass
        let view = UIImageView(frame: frame)
        let name = getImageString()
        if name == "" {
            view.image = UIImage()
        } else {
            view.image = UIImage(named: getImageString())
        }
        return view
    }
    func layout() {
        mView?.frame = mPosition.getFrame()
        layoutWithConstraint()

    }
    func layoutWithConstraint() {
        if mUsingInitialConstraints == nil {
            mView?.translatesAutoresizingMaskIntoConstraints = false
            addInitialConstraints(to: mView!)
            mUsingInitialConstraints = true
        }
    }
    func resetConstraints() {
 //       mView?.translatesAutoresizingMaskIntoConstraints = true
        if mUsingInitialConstraints! {
            mUsingInitialConstraints = false
            mView!.superview!.removeConstraint(mXConstraint!)
            mView!.superview!.removeConstraint(mYConstraint!)
            addAnimatableConstraints(to: mView!)
        }
    }
    func addInitialConstraints(to robot: UIView) {
        let view = mPosition.getView()
        
        mXConstraint = robot.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        mXConstraint?.identifier = "init"
        mYConstraint = robot.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        mYConstraint?.identifier = "init"
        NSLayoutConstraint.activate ([
            mXConstraint!,
            mYConstraint!,
            robot.widthAnchor.constraint(equalTo: view.widthAnchor),
            robot.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
    }
    func addAnimatableConstraints(to robot: UIView) {
        let stackView  = mBoard!.getController().getBoardStack()
        let frame  = mPosition.getFrame()
        let view = mPosition.getView()
        mXConstraint = robot.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: frame.minX)
        mXConstraint!.identifier = "leftRobot"
        mYConstraint = robot.topAnchor.constraint(equalTo: stackView.topAnchor, constant: frame.minY)
        mYConstraint!.identifier = "topRobot"
        
        NSLayoutConstraint.activate ([
            mXConstraint!,
            mYConstraint!,
            robot.widthAnchor.constraint(equalTo: view.widthAnchor),
            robot.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
    }
    func minimise() {
        mView?.frame = CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1)
        
    }
    func getImageString() -> String {  // Always overwritten
        return ""
    }
    func animateMove(from: BoardSquare, to: BoardSquare) {
       UIView.animate(withDuration: mBoard!.getSpeed(), delay: 0.0,options: UIViewAnimationOptions.curveEaseOut,animations: {
            let targetFrame = to.getFrame()
            self.mXConstraint!.constant = targetFrame.minX
            self.mYConstraint!.constant = targetFrame.minY
            self.mView!.superview!.layoutIfNeeded()
        },completion: nil)

    }
    func getPosition() ->BoardSquare {
        return mPosition
    }
    func getDirection() ->Direction {
        return mDirection
    }
    func kill() {
        animateKill()
        mView?.removeFromSuperview()
        mPosition.removeRobot(self)
        mBoard?.removeRobot(self)
        if let rubbishVolume = createsRubbish() {
            let rubIfExists = mPosition.getContent().filter {$0 is RubbishRobot}

            if rubIfExists.count == 0 {
                let rub = RubbishRobot(position: mPosition, direction: .right, board: mBoard!)
                rub.setVolume(volume: rubbishVolume)
                mBoard!.addHouseRobot(robot: rub)
            } else {
                let rub1 = rubIfExists[0] as! RubbishRobot
                rub1.setVolume(volume: rub1.getVolume() + rubbishVolume)
            }
            
        }
        
    }
    func animateKill() {
        
    }
    func createsRubbish() -> Int? {
        return nil
    }
    func destroy(cause: CauseOfDeath) {
        kill()
    }
    
    func moveAfterAlternativeAction() -> Bool {
        // forward is blocked, so do something else.  This is where the house robots have their
        // movement rules built in.
        // Return true if you want to turn and then move in one move
        return false
    }
    func moveAfterTurn(direction: Direction) -> Bool {
        var current = 0
        var goRight: Bool
        for i in 1...4 {
            if C.DIR_SEQUENCE[i] == mDirection {
                current = i
                break
            }
        }
        if direction == .right {
            current -= 1
            goRight = true
        } else {
            current += 1
            goRight = false
        }
        /*
        Check if there is a fence if we turn in the original direction
        If there is then we want to turn in the opposite way if there is no fence that way
        Otherwise carry on in the same direction
        */
        let fenceType = mPosition.getFenceType(in: C.DIR_SEQUENCE[current])
        if fenceType != .none {
            let newFence = mPosition.getFenceType(in: C.DIR_SEQUENCE[current + 2])
            if newFence == .none {
                goRight = !goRight
            }
        }
        if goRight {
            return turnRight()
        } else {
            return turnLeft()
        }
        
    }
    func animateBump() {
        let current = mView!.frame
        let speed = mBoard!.getSpeed()
        //Following fails if on edge.
        let fullMove: CGRect = {
            if let target = mPosition.getNext(in: mDirection) {
                return target.getFrame()
            } else {
                let size = CGSize(width: current.width, height: current.height)
                switch mDirection {
                case .right:
                    return CGRect(origin: CGPoint(x: current.minX + current.width, y: current.minY), size: size)
                case .left:
                    return CGRect(origin: CGPoint(x: current.minX - current.width, y: current.minY), size: size)
                case .up:
                    return CGRect(origin: CGPoint(x: current.minX , y: current.minY + current.height), size: size)
                case .down:
                    return CGRect(origin: CGPoint(x: current.minX , y: current.minY - current.height), size: size)
                }
            }
        }()
      
        let targFrame = CGRect(x: (current.minX * 3 + fullMove.minX ) / 4.0 , y: (current.minY * 3 + fullMove.minY ) / 4.0 , width: current.width, height: current.height )
        UIView.animate(withDuration: speed / 2.0, delay: 0.0,options: UIViewAnimationOptions.curveEaseOut,animations: {
            self.mView?.frame = targFrame
        },completion: nil)
        UIView.animate(withDuration: speed / 2.0, delay: speed,options: UIViewAnimationOptions.curveEaseOut,animations: {
                self.mView?.frame = current
        },completion: nil)
        

    }
    func turn(towards robot: Robot) {
        let targetDirection = C.turn(direction: robot.direction, turnDir: .opposite)
        let speed =  mBoard!.getSpeed()
        let radians = atan2f(Float(mView!.transform.b), Float(mView!.transform.a));
        let delta = C.deltaAngle(from: self.direction, to: targetDirection)
        self.mDirection = targetDirection
        UIView.animate(withDuration: speed, animations: {
            self.mView!.transform = CGAffineTransform(rotationAngle: CGFloat(radians + delta))
        })
    }
}
