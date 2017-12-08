//
//  SplashToaster.swift
//  Robots
//
//  Created by Pete Bennett on 30/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class SplashToaster: UIView {
    var mBackView: UIImageView
    var mFrontView: UIImageView
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        mBackView = UIImageView()
        mBackView.image = UIImage(named: "toasterBack")
        mFrontView = UIImageView()
        mFrontView.image = UIImage(named: "toasterFront")
        super.init(coder: aDecoder)
        self.addSubview(mBackView)
        self.addSubview(mFrontView)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mBackView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        mFrontView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
    func makeToast() {
        let particleEmitter = CAEmitterLayer()
        let viewDim = self.frame.size.width
        let x = viewDim * 165  / 400
        let y = viewDim * 150 / 400
        
        particleEmitter.emitterPosition = CGPoint(x: x, y: y)
        particleEmitter.emitterShape = kCAEmitterLayerPoint
        particleEmitter.emitterSize =  CGSize(width: viewDim / 2.0, height: 1.0)
        
        let toast = makeUpCell(image: "toastVertical")
  
        
        particleEmitter.emitterCells = [toast]
        
        mBackView.layer.addSublayer(particleEmitter)
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            particleEmitter.birthRate = 0
            particleEmitter.removeFromSuperlayer()
            self.becomeEvil()
        }
        
    }
    func becomeEvil() {
        let newBack = UIImageView(frame: mBackView.frame)
        newBack.image = UIImage(named: "toasterBackAngry")
        newBack.alpha = 0.0
        self.addSubview(newBack)
        
        let newFront = UIImageView(frame: mFrontView.frame)
        newFront.image = UIImage(named: "toasterFrontAngry")
        newFront.alpha = 0.0
        self.addSubview(newFront)
        UIView.animate(withDuration: 1.0, animations: {
            self.mBackView.alpha = 0.0
            self.mFrontView.alpha = 0.0
            newFront.alpha = 1.0
            newBack.alpha = 1.0
        }, completion: {complete in
            let particleEmitter = CAEmitterLayer()
            let viewDim = self.frame.size.width
            let x = viewDim * 270  / 400
            let y = viewDim * 250 / 400
            
            particleEmitter.emitterPosition = CGPoint(x: x, y: y)
            particleEmitter.emitterShape = kCAEmitterLayerPoint
 //           particleEmitter.emitterSize =  CGSize(width: viewDim / 2.0, height: 1.0)
            
            let toast = self.makeShootCell(image: "toastHorizontal")
            
            
            particleEmitter.emitterCells = [toast]
            
            newBack.layer.addSublayer(particleEmitter)
            self.increaseSpeedOfToast(speed: 50, volume: 10, speedDelta: 5, volumeDelta: 20, particleEmitter: particleEmitter)
            let when = DispatchTime.now() + 3.0
            DispatchQueue.main.asyncAfter(deadline: when) {
                particleEmitter.birthRate = 0
                particleEmitter.removeFromSuperlayer()
            }
        })
    }
    func increaseSpeedOfToast(speed: Float, volume: Float, speedDelta: Float, volumeDelta: Float, particleEmitter: CAEmitterLayer) {
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) {
            if particleEmitter.superlayer != nil {
                self.increaseSpeedOfToast(speed: speed + speedDelta, volume: volume + volumeDelta,
                                          speedDelta: speedDelta, volumeDelta: volumeDelta, particleEmitter: particleEmitter)
                particleEmitter.birthRate = volume + volumeDelta
                particleEmitter.velocity = speed + speedDelta
            }
        }
    }
    func makeUpCell(image: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = 0.3
        cell.velocity = 30
        cell.emissionLongitude = -CGFloat.pi / 2

        cell.lifetime = 6.0
        cell.lifetimeRange = 0
        cell.color = UIColor.lightGray.cgColor
        cell.redRange = 0.05
        cell.greenRange = 0.05
        cell.blueRange = 0.05
        cell.velocityRange = 10
        //  cell.emissionLongitude = 0.0
        cell.emissionRange = 0.1
        cell.spin = 0
        cell.spinRange = 0
        cell.scaleRange = 0.0
        cell.scale = 0.9
        //        cell.scaleSpeed = -0.5
        
        let dim = self.frame.size.height * 100.0 / 400.0
        cell.contents = UIImage(named: image)?.resize(targetSize: CGSize(width: dim, height: dim)).cgImage
        return cell
    }
    func makeShootCell(image: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = 10.0
        cell.velocity = 50
        cell.emissionLongitude = 0.0
        

        cell.lifetime = 6.0
        cell.lifetimeRange = 0
        cell.color = UIColor.lightGray.cgColor
        cell.redRange = 0.05
        cell.greenRange = 0.05
        cell.blueRange = 0.05
        cell.velocityRange = 10
        //  cell.emissionLongitude = 0.0
        cell.emissionRange = 0.8
        cell.spin = 0
        cell.spinRange = 0
        cell.scaleRange = 0.0
        cell.scale = 0.9
        //        cell.scaleSpeed = -0.5
        
        let dim = mFrontView.frame.size.height / 5.0
        cell.contents = UIImage(named: image)?.resize(targetSize: CGSize(width: dim, height: dim)).cgImage
        return cell
    }

}
