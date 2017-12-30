//
//  Test2ViewController.swift
//  Cleanobot
//
//  Created by Pete Bennett on 13/12/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class Test2ViewController: UIViewController {
    var fView: LaundryFinishedView!
    @IBAction func pressButton(_ sender: Any) {
        fView.rotateEyes()
    }
    @IBOutlet weak var fenceview: Fence2View!
    var mFence2: FenceDoor2!
    
    @IBOutlet weak var imageViews: UIImageView!
    override func viewDidLoad() {
        fView = LaundryFinishedView(frame: imageViews.frame, completion: yyy)
        imageViews.addSubview(fView)
    }
    func yyy() {
        fView.removeFromSuperview()
    }
    func xxx() {
        super.viewDidLoad()
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.animateIt()
        })
        mFence2 = FenceDoor2(status: .closed)
        fenceview.setFence(fence: mFence2, direction: .right)
        // Do any additional setup after loading the view.
        doAnim()
    }
    func doAnim() {
        mFence2.cycleStatus()
        self.fenceview.setFence(fence: mFence2, direction: .right)
        let when = DispatchTime.now() + 10.0
  //      DispatchQueue.main.asyncAfter(deadline: when, execute: self.doAnim())
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.doAnim()
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func animateIt() {
        imageViews.animationImages = [#imageLiteral(resourceName: "robbieSmall"),#imageLiteral(resourceName: "happyImage"),#imageLiteral(resourceName: "binImage"),#imageLiteral(resourceName: "heartImage")]
        imageViews.animationRepeatCount = 1
        imageViews.animationDuration = 3.0
        imageViews.image = #imageLiteral(resourceName: "toasterFront")
        imageViews.startAnimating()
        let when = DispatchTime.now() + 4.0
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.animateIt()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
