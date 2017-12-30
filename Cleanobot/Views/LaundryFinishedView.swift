//
//  LaundryFinishedView.swift
//  Cleanobot
//
//  Created by Pete Bennett on 28/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class LaundryFinishedView: FinishedImageView, CAAnimationDelegate {
    var mEyes: UIImageView!
    var mAnimCount = 3
    override init( frame: CGRect, completion: @escaping ()->Void) {
        super.init(frame: frame, completion: completion)
        doAction()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func doAction() {
        self.image = #imageLiteral(resourceName: "washingMachine")
        mEyes = UIImageView()
        self.addSubview(mEyes)
        mEyes.image = #imageLiteral(resourceName: "eyesImage")
        
        mEyes.translatesAutoresizingMaskIntoConstraints = false
        let yConstraint = NSLayoutConstraint(item: mEyes, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.1, constant: 0)
        
        let xConstraint = NSLayoutConstraint(item: mEyes, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.3, constant: 0)
        let hConstraint = NSLayoutConstraint(item: mEyes, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.06, constant: 0)
        let wConstraint = NSLayoutConstraint(item: mEyes, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.1, constant: 0)
        NSLayoutConstraint.activate ([
            xConstraint,
            yConstraint,
            hConstraint,
            wConstraint])
        self.layoutIfNeeded()
        blinkEyes()
        mEyes.startAnimating()
        rotateEyes()
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if mAnimCount == -3 {
            return
        }
        if mAnimCount == 1 {
            closeEyes()
        } else {
            if mAnimCount > 1 {
                blinkEyes()
            }
        }
        mAnimCount -= 1
        rotateEyes()
    }
    func blinkEyes() {
        let im1 = #imageLiteral(resourceName: "eyesImage")
        mEyes.animationImages = [im1,#imageLiteral(resourceName: "eyesOpen.0"),#imageLiteral(resourceName: "eyesOpen.1"),#imageLiteral(resourceName: "eyesOpen.2"),#imageLiteral(resourceName: "eyesOpen.3"),#imageLiteral(resourceName: "eyesOpen.4"),#imageLiteral(resourceName: "eyesOpen.5"),#imageLiteral(resourceName: "eyesOpen.6"),#imageLiteral(resourceName: "eyesOpen.7"),#imageLiteral(resourceName: "eyesOpen.6"),#imageLiteral(resourceName: "eyesOpen.5"),#imageLiteral(resourceName: "eyesOpen.4"),#imageLiteral(resourceName: "eyesOpen.3"),#imageLiteral(resourceName: "eyesOpen.2"),#imageLiteral(resourceName: "eyesOpen.1"),#imageLiteral(resourceName: "eyesOpen.0"),im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1,im1]
        mEyes.animationDuration = 0.5
        mEyes.animationRepeatCount = 1
        mEyes.startAnimating()
    }
    
    func closeEyes() {
        let im1 = #imageLiteral(resourceName: "eyesImage")
        mEyes.animationImages = [im1,#imageLiteral(resourceName: "eyesOpen.0"),#imageLiteral(resourceName: "eyesOpen.1"),#imageLiteral(resourceName: "eyesOpen.2"),#imageLiteral(resourceName: "eyesOpen.3"),#imageLiteral(resourceName: "eyesOpen.4"),#imageLiteral(resourceName: "eyesOpen.5"),#imageLiteral(resourceName: "eyesOpen.6"),#imageLiteral(resourceName: "eyesOpen.7"),#imageLiteral(resourceName: "eyesOpen.6")]
        mEyes.animationDuration = 2.0
        mEyes.animationRepeatCount = 1
        mEyes.startAnimating()
        mEyes.image = nil
        let when = DispatchTime.now() + 3.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.completed()
        }
    }
    func rotateEyes() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.delegate = self
        mEyes.layer.anchorPoint = CGPoint(x: -0.1, y: 1.3)
        
   //     rotateAnimation.delegate =
      
        mEyes.layer.add(rotateAnimation, forKey: nil)
 /*       let yConstraint = eyesImage.centerYAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        
        
        mConstraint = mOverImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -mMargin!)
        let heightConstraint = mOverImage.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -2 * mMargin!)
        let widthConstraint = mOverImage.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2 * mMargin!)
        //      let heightConstraint = overImage.heightAnchor.constraint(equalTo: self.heightAnchor)
        //      let widthConstraint = overImage.widthAnchor.constraint(equalTo: self.widthAnchor)
        
        let yConstraint = mOverImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let image0 = UIImage(named: "robbieexpand0")
        let image1 = UIImage(named: "robbieexpand1")
        let image2 = UIImage(named: "robbieexpand2")
        let image3 = UIImage(named: "robbieexpand3")
        let image4 = UIImage(named: "robbieexpand4")
        let image5 = UIImage(named: "robbieexpand5")
        overImage.image = image5!
        overImage.animationImages = [image0!,image1!,image2!,image3!,image4!,image5!]
        overImage.animationDuration = 4.0
        overImage.animationRepeatCount = 1
        overImage.startAnimating() */
    }
}
