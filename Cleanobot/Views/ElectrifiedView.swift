//
//  ElectrifiedView.swift
//  Robots
//
//  Created by Pete Bennett on 06/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class ElectrifiedView: FinishedImageView {
    override init( frame: CGRect, completion: @escaping ()->Void) {
        super.init(frame: frame, completion: completion)
        doAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func doAction() {
        let image0 = UIImage(named: "Electrified1")!
        let image1 = UIImage(named: "Electrified2")!
        let image2 = UIImage(named: "Electrified3")!
        let image3 = UIImage(named: "Electrified4")!
        var images = [image0]
        for _ in 0...100 {
            images.append(image1)
            images.append(image2)
        }
        images.append(image3)
        self.image = image0
        self.animationDuration = 3.0
        self.animationRepeatCount = 1
        var when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.image = image3  // must set this before setting animationimages, otherwise ignored
            self.animationImages = images
            self.startAnimating()
        }
        when = DispatchTime.now() + 4.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.completed()
        }
    
    }
}
