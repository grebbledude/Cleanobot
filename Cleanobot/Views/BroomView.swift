//
//  BroomView.swift
//  Robots
//
//  Created by Pete Bennett on 01/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class BroomView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        
        fatalError("init(frame) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init (parent: UIView) {
        
        super.init(frame: parent.frame)
        image = UIImage(named: "broomImage")
        
        parent.superview?.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi / 2))
        }, completion: { complete in
            self.removeFromSuperview()
        })
    }
}
