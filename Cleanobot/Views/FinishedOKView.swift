//
//  FinishedOKView.swift
//  Robots
//
//  Created by Pete Bennett on 10/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class FinishedOKView: FinishedImageView{
    
    override init( frame: CGRect, completion: @escaping ()->Void) {
        super.init(frame: frame, completion: completion)
        doAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func doAction() {
        self.image = UIImage(named: "leaving1")
        self.clipsToBounds = true
        let layerRobbie = CALayer()
        let frameRobbie = CGRect(x: self.frame.size.width, y: 3.0 * self.frame.size.height / 5.0, width: self.frame.size.width / 3.0, height: self.frame.size.height / 3.0)
        layerRobbie.frame = frameRobbie
        layerRobbie.zPosition = 2.0
        layerRobbie.contents = UIImage(named: "robbieLarge")!.cgImage
        self.layer.addSublayer(layerRobbie)
        let layerOverlay = CALayer()
        let frameOverlay = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        layerOverlay.frame = frameOverlay
        layerOverlay.zPosition = 3.0
        layerOverlay.contents = UIImage(named: "leaving2")!.cgImage
        self.layer.addSublayer(layerOverlay)
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = CGPoint(x: 0.0, y: layerRobbie.position.y)
        anim.toValue = layerRobbie.position
        
        anim.duration = 3.0
        layerRobbie.add(anim, forKey: "position")
        
        
        let when = DispatchTime.now() + 3.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.doEmitter()
        }
        
    }
    
    
    func doEmitter() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: self.frame.width * 2.0 / 3.0, y: self.center.y)
        particleEmitter.emitterShape = kCAEmitterLayerSphere
        particleEmitter.emitterSize = CGSize( width: self.frame.width / 3.0, height: self.frame.height / 2.0)
        
        let star = makeEmitterCell(image: "star")
        
        particleEmitter.emitterCells = [star]
        
        self.layer.addSublayer(particleEmitter)
        
        var when = DispatchTime.now() + 0.9
        DispatchQueue.main.asyncAfter(deadline: when) {
            particleEmitter.birthRate = 0
        }
        when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.completed()
        }
    }
    
    
    func makeEmitterCell(image: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 100
        cell.lifetime = 3.0
        cell.lifetimeRange = 0
        cell.color = UIColor.lightGray.cgColor
        cell.redRange = 1.0
        cell.greenRange =   1.0
        cell.blueRange = 1.0
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi * 2.0
        cell.spin = 2
        cell.spinRange = 3
        cell.scale = 0.3
        cell.scaleRange = 0.1
        cell.scaleSpeed = -0.1
        cell.alphaSpeed = 3.0
        
        cell.contents = UIImage(named: image)?.cgImage
        return cell
    }
    
    
}
