//
//  FenceDoor.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class FenceDoor: Fence {
    static let OPENING = [UIImage(named: "doorOpening1")!,
                          UIImage(named: "doorOpening2")!,
                          UIImage(named: "doorOpening3")!,
                          UIImage(named: "doorOpening4")!,
                          UIImage(named: "doorOpening5")!]
    
    static let CLOSED = [UIImage(named: "doorClosed1")!,
                          UIImage(named: "doorClosed2")!,
                          UIImage(named: "doorClosed3")!,
                          UIImage(named: "doorClosed4")!,
                          UIImage(named: "doorClosed5")!]
    static let OPEN = [UIImage(named: "doorOpen1")!,
                          UIImage(named: "doorOpen2")!,
                          UIImage(named: "doorOpen3")!,
                          UIImage(named: "doorOpen4")!,
                          UIImage(named: "doorOpen5")!]
    
    
    enum DoorStatus: String {
        case open
        case closed
        case opening
    }
    var mStatus: DoorStatus
    var mPosition: FencePosition?
    var status: DoorStatus {
        get {
            return mStatus
        }
    }

    init (status: DoorStatus, position: FencePosition) {
        mStatus = status
        mPosition = position
        super.init()
    }
    override init() {
        mStatus = .closed
        super.init()
    }
    override var type: FenceType {
        return (mStatus == .open) ? .none : .electrified
    }
    override var fenceClass: FenceObject {
        get {return .door}
    }
    override var image: UIImage {
        get {
            switch mStatus {
            case .closed:
                return UIImage(named: "doorClosed")!
            case .opening:
                return UIImage(named: "doorOpening")!
            case .open:
                return UIImage(named: "doorOpen")!
            }
        }
    }
    func cycleStatus()  {

        switch mStatus {
        case .open:
            mStatus =  .closed
        case .closed:
            mStatus =  .opening
        case .opening:
            mStatus =  .open
        }
        mPosition?.display()
        
    }
    
    override func setAnimatingImages(for imageView: UIImageView) -> Bool {

        switch mStatus {
        case .closed:
            imageView.animationImages = FenceDoor.OPEN
        case .opening:
            imageView.animationImages = FenceDoor.CLOSED
        case .open:
            imageView.animationImages = FenceDoor.OPENING
        }

   
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = 1
        return true
    }
}
