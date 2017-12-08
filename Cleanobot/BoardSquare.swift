//
//  BoardSquare.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class BoardSquare {


    var mFences: [Direction : FencePosition] = [:]
    var mContents: [Robot] = []
    let x: Int
    let y: Int
    weak var mBoard: Board?
    init(x: Int, y:Int, board: Board) {
        self.x = x
        self.y = y
        mBoard = board
    }
    func cleanup() {
        mFences = [:]
        mContents = []
    }
    func getFenceType(in direction: Direction) ->FenceType {
        if let fence = mFences[direction] {
            return fence.getType()
        } else {
            return .edge
        }
    }
    
    
    func getFenceClass(in direction: Direction) ->FenceObject? {
        if let fence = mFences[direction] {
            return fence.fenceClass
        }
        return nil
  
    }
    func getFence(in direction: Direction) ->FencePosition? {
        return mFences[direction]
    }
    func getNext(in direction: Direction) -> BoardSquare? {
        if let fence = mFences[direction] {
            return fence.getNext(in: direction)
        } else {
            return nil
        }
    }
    func setFence(fence: FencePosition, in direction: Direction) {
        mFences[direction] = fence
    }
    func removeContent(_ robot: Robot) {
        mContents = mContents.filter { $0 !== robot }
    }
    func addContent(_ robot: Robot) {
        mContents.append(robot)
    }
    func getContent() -> [Robot] {
        return mContents
    }
    func getView() -> FenceView {
        return mBoard!.getController().getBoardView(x: x, y: y)
    }
    func getFrame() -> CGRect {
        let view = getView()

        let boardView = mBoard!.getController().getBoardStack()

        
        let frame = view.superview!.convert(view.frame, to: boardView)
        return frame
        
    }
 /*   func addConstraints(to robot: UIView) {
        let view = getView()
        
        let centerXConstraint = robot.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        centerXConstraint.identifier = "init"
        let centerYConstraint = robot.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.identifier = "init"
        NSLayoutConstraint.activate ([
            centerXConstraint,
            centerYConstraint,
            robot.widthAnchor.constraint(equalTo: view.widthAnchor),
            robot.heightAnchor.constraint(equalTo: view.heightAnchor)])
 
    }
    func addViewConstraints(to robot: UIView) {
        let stackView  = mBoard!.getController().getBoardStack()
        let frame  = getFrame()
        let view = getView()
        print(frame)
        let leftConstraint = robot.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: frame.minX)
        leftConstraint.identifier = "leftRobot"
        let topConstraint = robot.topAnchor.constraint(equalTo: stackView.topAnchor, constant: frame.minY)
        topConstraint.identifier = "topRobot"
        
        NSLayoutConstraint.activate ([
            leftConstraint,
            topConstraint,
            robot.widthAnchor.constraint(equalTo: view.widthAnchor),
            robot.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
    } */
    func removeRobot(_ robot: Robot) {
        mContents = mContents.filter {$0 !== robot }
    }
    
}
