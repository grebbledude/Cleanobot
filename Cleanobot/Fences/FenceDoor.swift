//
//  FenceDoor.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class FenceDoor: Fence {
    
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
}
