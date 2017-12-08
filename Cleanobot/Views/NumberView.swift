//
//  NumberView.swift
//  Robots
//
//  Created by Pete Bennett on 27/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class NumberView: UIView {
    var mImage: UIImage!
    var mCurrentValue = 0
    var scrollLayer: CAScrollLayer!
    var leftContentLayer: CALayer!
    var rightContentLayer: CALayer!
    @IBInspectable var value: Int {
        get {
            return mCurrentValue
        }
        set (newValue) {
            mCurrentValue = newValue
            UIView.animate(withDuration: 0.5, animations: {
                self.setPositions()
            })
        }
    }
    

    init(frame: CGRect, number: Int) {
        super.init(frame: frame)
        initValues()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initValues()
    }
    func initValues() {
        
        mImage = UIImage(named: "numSlide")!
        scrollLayer = CAScrollLayer()
        leftContentLayer = CALayer()
        rightContentLayer = CALayer()
        
        scrollLayer.position = CGPoint(x: 0.0, y: 0.0)
//        scrollLayer.borderColor = UIColor.black.cgColor
//        scrollLayer.borderWidth = 5.0
        scrollLayer.scrollMode = kCAScrollVertically
        
        scrollLayer.addSublayer(leftContentLayer)
        scrollLayer.addSublayer(rightContentLayer)
        self.layer.addSublayer(scrollLayer)
        resize()
    }
    func resize() {
        let size = self.frame.size
        let imgRatio = mImage.size.height / (mImage.size.width * 10)  // height / width for a digit.
        let sizeRatio = size.height * 2.0 / size.width // We have two digits, so need to account for both
        let newFrame: CGRect = {
            if sizeRatio > imgRatio {  //view is too thin
                let newHeight = size.width * imgRatio
                return CGRect(x: 0.0, y: (size.height - newHeight) / 2.0 , width: size.width, height: newHeight)
            } else {
                let newWidth = size.height / imgRatio
                return CGRect(x: (size.width - newWidth) / 2.0, y: 0.0, width: newWidth, height: size.height)
            }
        }()
        let newImgSize = CGSize(width: newFrame.width / 2.0 , height: newFrame.height * 10.0)
        let newImage = resizedImage(image: mImage, scaledToSize: newImgSize)
        leftContentLayer.contents = newImage.cgImage
        rightContentLayer.contents = newImage.cgImage
        scrollLayer.frame = newFrame
        
        leftContentLayer.bounds = CGRect(x: 0.0, y: 0.0, width: newImgSize.width, height: newImgSize.height)
        leftContentLayer.position = CGPoint(x: newImgSize.width / 4.0, y: 0) // 4
        
        rightContentLayer.bounds = CGRect(x: 0.0, y: 0.0, width: newImgSize.width, height: newImgSize.height)
        rightContentLayer.position = CGPoint(x: 3.0 * newImgSize.width / 4.0, y: 0) // 4
        setPositions()
        
        scrollLayer.scroll(to: CGPoint(x: 0.0, y: 0.0))
    }
    func setPositions() {
        let left = Int(mCurrentValue / 10)
        let right = mCurrentValue % 10
        
        leftContentLayer.anchorPoint = CGPoint(x: 0.0, y: CGFloat(left) / 10.0)
        rightContentLayer.anchorPoint = CGPoint(x: 0.0, y: CGFloat(right) / 10.0)
    }
    func resizedImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        resize()
    }

}

