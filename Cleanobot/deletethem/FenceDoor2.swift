//
//  FenceDoor2.swift
//  Cleanobot
//
//  Created by Pete Bennett on 16/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class FenceDoor2: Fence2 {
    static let OPENING = [UIImage(named: "doorOpening1")!,
                          UIImage(named: "doorOpening2")!,
                          UIImage(named: "doorOpening3")!,
                          UIImage(named: "doorOpening4")!,
                          UIImage(named: "doorOpening5")!]
    
    static let OPENING1 = [UIImage(named: "doorOpening1")!,
                          UIImage(named: "doorClosed2")!,
                          UIImage(named: "doorOpening3")!,
                          UIImage(named: "doorClosed4")!,
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
//    var mPosition: FencePosition2?
    var status: DoorStatus {
        get {
            return mStatus
        }
    }
    
    init (status: DoorStatus) {
        mStatus = status
  //      mPosition = position
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
   //     mPosition?.display()
        
    }
    
    override func setAnimatingImages(for imageView: UIImageView) -> Bool {
        let base: String = {
            switch mStatus {
            case .closed:
                imageView.animationImages = FenceDoor2.OPEN
                return "doorOpen"
            case .opening:
                imageView.animationImages = FenceDoor2.CLOSED
                return "doorClosed"
            case .open:
                imageView.animationImages = FenceDoor2.OPENING1
                return "doorOpening"
            }
        }()
        /*      imageView.animationImages = [UIImage(named: base + "1")!,
         UIImage(named: base + "2")!,
         UIImage(named: base + "3")!,
         UIImage(named: base + "4")!,
         UIImage(named: base + "5")!]
         imageView.stopAnimating() */
        imageView.animationDuration = 4.0
        imageView.animationRepeatCount = 1
        return true
    }
}

