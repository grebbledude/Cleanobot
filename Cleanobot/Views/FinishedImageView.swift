//
//  FinishedImageView.swift
//  Robots
//
//  Created by Pete Bennett on 31/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class FinishedImageView: UIImageView {

    var mCompletion: ()->Void
    init( frame: CGRect, completion: @escaping ()->Void) {
        mCompletion = completion
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func createView(view: UIView, cause: CauseOfDeath, completion: @escaping ()->Void) {
        
        var imageView: FinishedImageView
        let frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        switch cause {
        case .damage:
            imageView = DamageView(frame: frame, completion: completion)
        case .electrocuted:
            imageView = ElectrifiedView(frame: frame, completion: completion)
        case .survived:
            imageView = FinishedOKView(frame: frame, completion: completion)
        case .capacityExceeded:
            imageView = ExplodeRubbishFinishView(frame: frame, completion: completion)
        default:
            imageView = DamageView(frame: frame, completion: completion)
        }
        view.superview?.addSubview(imageView)

    }

    func completed () {
        self.removeFromSuperview()
        mCompletion()
    }

}
protocol FinishView {
    func doAction(completion: ()->Void)
}
