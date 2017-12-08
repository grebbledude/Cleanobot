//
//  ExplodeRubbishFinishView.swift
//  Robots
//
//  Created by Pete Bennett on 27/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class ExplodeRubbishFinishView: FinishedImageView {
    var mConstraint: NSLayoutConstraint?
    var mMargin: CGFloat?
    weak var mOverImage: UIImageView!
    override init( frame: CGRect, completion: @escaping ()->Void) {
        super.init(frame: frame, completion: completion)
        doAction()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func doAction() {
        image = UIImage(named: "hooverrubbish")!
        layoutIfNeeded()
        let overImage = UIImageView(frame: CGRect.zero)  //prevent weak allowing release
        mOverImage = overImage
        mMargin = frame.width / 10.0
        addSubview(mOverImage)
        mOverImage.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        overImage.startAnimating()
        

        NSLayoutConstraint.activate ([
            mConstraint!,
            yConstraint,
            heightConstraint,
            widthConstraint])
        self.layoutIfNeeded()
        moveRight(iteration: 0)

    }
    func moveLeft(iteration: Int) {
        if iteration == 5 {
            self.doEmitter()
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.mConstraint!.constant = -self.mMargin!
            self.layoutIfNeeded()
        }, completion: {(complete) in
            print(complete)
            
            self.moveRight(iteration: iteration + 1)
        })
    }
    func moveRight(iteration: Int) {
        UIView.animate(withDuration: 0.5, animations: {
            self.mConstraint!.constant = self.mMargin!
            self.layoutIfNeeded()
        }, completion: {(complete) in
            print("here now")
            self.moveLeft(iteration: iteration)
        })
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
            self.mOverImage.removeFromSuperview()
            self.image = UIImage(named: "scrap2")!
        }
        when = DispatchTime.now() + 8.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.completed()
        }
        
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
