//
//  FlashImageView.swift
//  Robots
//
//  Created by Pete Bennett on 28/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

@IBDesignable

class FlashImageView: UIView {
    var mImage: UIImage?
    @IBInspectable var  image: UIImage? {
        didSet  {
            self.mImage = image
            showImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        showImage()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        showImage()
    }
    func showImage() {
        if let image = mImage {
            layer.contents = image.cgImage
            return
            
        }
        layer.contents = nil
    }
    func flashImage() {
        let currFrame = layer.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.bounds = CGRect(x: currFrame.minX / 2.0 - 1.0, y: (currFrame.minY / 2.0) - 1.0 , width: 1.0, height: 1.0 )
        })
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            self.layer.bounds = currFrame
        }, completion: nil)
    }


}
