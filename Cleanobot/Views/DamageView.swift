//
//  DamageView.swift
//  Robots
//
//  Created by Pete Bennett on 09/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class DamageView: FinishedImageView {

    var mShakes = 0
    var leftFrame: CGRect?
    var rightFrame: CGRect?
    var origFrame: CGRect?
    override init( frame: CGRect, completion: @escaping ()->Void) {
        super.init(frame: frame, completion: completion)
        self.image = UIImage(named: "robbieLarge")
        doAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func doAction() {
        let curr = self.frame
        let delta = curr.width / 30.0
        origFrame = curr
        leftFrame = CGRect(x: curr.minX - delta, y: curr.minY - delta,  width: curr.width + 2 * delta, height: curr.height + 2 * delta)
        rightFrame = CGRect(x: curr.minX + delta, y: curr.minY + delta,  width: curr.width - 2 * delta, height: curr.height - 2 * delta)
        shakeLeft()
    }
    func doEmitter() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: self.center.x, y: -96)
        particleEmitter.emitterShape = kCAEmitterLayerSphere
        particleEmitter.emitterSize = self.frame.size
        
        let cloud1 = makeCloud(image: "cloud1")
        let cloud2 = makeCloud(image: "cloud2")
        let cloud3 = makeCloud(image: "cloud3")
        let cog1 = makeEmitterCell(image: "cog1")
        let cog2 = makeEmitterCell(image: "cog2")
        let chain1 = makeEmitterCell(image: "chain1")
        
        particleEmitter.emitterCells = [cloud1, cloud2, cloud3, cog1, cog2, chain1]
        
        self.layer.addSublayer(particleEmitter)
        
        var when = DispatchTime.now() + 0.9
        DispatchQueue.main.asyncAfter(deadline: when) {
            particleEmitter.birthRate = 0
            self.image = UIImage(named: "scrap2")
        }
        when = DispatchTime.now() + 8.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            particleEmitter.birthRate = 0
            self.completed()
        }
        
    }

    func shakeLeft() {
        
        UIView.animate(withDuration: 0.05, animations: {
            self.frame = self.leftFrame!
        }, completion: { (complete) -> Void in
            self.shakeRight()
        })
    }
    func shakeRight() {
        
        
        UIView.animate(withDuration: 0.05,  animations: {
            self.frame = self.rightFrame!
        }, completion: { (complete) -> Void in
            self.mShakes += 1
            if self.mShakes < 10 {
                self.shakeLeft()
            } else {
                self.restoreFrame()
            }
        })
    }
    func restoreFrame() {
        doEmitter()
        UIView.animateKeyframes(withDuration: 0.05, delay: 0.0, options: [], animations: {
            self.frame = self.origFrame!
        })
    }
    func makeEmitterCell(image: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 3.0
        cell.lifetimeRange = 0
        cell.color = UIColor.lightGray.cgColor
        cell.redRange = 0.2
        cell.greenRange = 0.2
        cell.blueRange = 0.2
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi * 2.0
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 1.0
        cell.scaleSpeed = -0.1
        
        cell.contents = UIImage(named: image)?.cgImage
        return cell
    }
    func makeCloud(image: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 30
        cell.lifetime = 6.0
        cell.lifetimeRange = 0
        cell.color = UIColor.lightGray.cgColor
        cell.redRange = 0.05
        cell.greenRange = 0.05
        cell.blueRange = 0.05
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi * 2.0
        cell.spin = 2
        cell.spinRange = 1
        cell.scaleRange = 2.0
        cell.scale = 3.0
        cell.scaleSpeed = -0.5
        
        cell.contents = UIImage(named: image)?.cgImage
        return cell
    }
    
}

