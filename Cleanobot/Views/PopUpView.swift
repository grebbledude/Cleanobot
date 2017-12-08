//
//  PopupView.swift
//  Robots2
//
//  Created by Pete Bennett on 31/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class PopUpView: UILabel {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    init(screen: UIView, message: String) {
        let frame = screen.frame
        let height = frame.height / 8.0
        let newFrame = CGRect(x: frame.minX, y: frame.height - height, width: frame.maxX, height: height)
        super.init(frame: newFrame)
        self.textAlignment = .center
        self.backgroundColor = .yellow
        self.text = message
        screen.addSubview(self)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc private func timerAction() {
        self.removeFromSuperview()
    }
    
}
