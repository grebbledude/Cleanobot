//
//  Fence2View.swift
//  Cleanobot
//
//  Created by Pete Bennett on 16/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class Fence2View: UIView {
    var mFences: [Direction: UIImageView] = [:]
    @IBInspectable var initial: String?
    var initialValue: FenceObject {
        get {
            if let initV = initial {
                switch initV {
                case "normal":
                    return .normal
                case "electric":
                    return .electric
                    
                case "door":
                    return .door
                default:
                    return .normal
                }
            }
            return .normal
        }
    }
    
    func setFence(fence: Fence2, direction: Direction) {
        if fence.fenceClass == .none {
            if let imageView = mFences[direction] {
                imageView.removeFromSuperview()
                mFences.removeValue(forKey: direction)
                return
            }
        }
        let view: UIImageView = {
            if let imageView = mFences[direction] {
                return imageView
            }
            return getNewView(direction: direction)
        }()
        if fence.setAnimatingImages(for: view) {
            view.startAnimating()
        }
        view.image = fence.image
        
    }
    
    
    func getNewView(direction: Direction) -> UIImageView {
        
        let slim = self.frame.size.height / 10.0
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.height, height: slim))
        
        let maskView = UIView(frame: imageView.frame)
        let path = getPath(width: self.frame.size.height, slim: slim)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.frame
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.path = path.cgPath
        maskView.layer.addSublayer(shapeLayer)
        imageView.addSubview(maskView)
        self.addSubview(imageView)
        imageView.mask = maskView
        switch direction {
        case .up:
            break
        case .down:
            setAnchorPoint(view: imageView, anchorPoint: CGPoint(x: 0.5, y: 5))
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi  ))
        case .right:
            setAnchorPoint(view: imageView, anchorPoint: CGPoint(x: 0.5, y: 5))
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi / 2.0 ))
        case .left:
            setAnchorPoint(view: imageView, anchorPoint: CGPoint(x: 0.5, y: 5))
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-CGFloat.pi / 2.0 ))
            
        }
        mFences[direction] = imageView
        return imageView
    }
    func setAnchorPoint(view: UIView, anchorPoint: CGPoint) {
        
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    func getPath(width: CGFloat, slim: CGFloat) -> UIBezierPath{
        let fencePath = UIBezierPath()
        fencePath.move(to: CGPoint.zero)
        fencePath.addLine(to: CGPoint(x: width, y: 0.0))
        fencePath.addLine(to: CGPoint(x: width-slim, y: slim))
        fencePath.addLine(to: CGPoint(x: slim, y: slim))
        fencePath.close()
        return fencePath
    }
    
}


