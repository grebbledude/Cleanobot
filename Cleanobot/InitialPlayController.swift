//
//  InitialPlayController.swift
//  Robots
//
//  Created by Pete Bennett on 12/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class InitialPlayController: PlayController {
    var mFingerImage: UIImageView?
    var mStart: CGPoint?
    var mFinish: CGPoint?
    var mStatus = 0

  
  
    @IBOutlet weak var instLabelConst: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    
    
    @IBOutlet weak var powerView: PowerView!
    override var powerNum: PowerView {
        get {return powerView}
    }
    @IBOutlet weak var instructionsLabel: UILabel!
    override func viewDidLoad() {
        mFloor = 1
        mRoom = 1
        mHealth =  C.INITIAL_HEALTH
        mFinalHealth = C.INITIAL_HEALTH
        mOrigHealth = C.INITIAL_HEALTH
        mHappiness = C.INITIAL_HAPPINESS
        mOrigHappiness = C.INITIAL_HAPPINESS
        mCapacity = C.INITIAL_CAPACITY
        mOrigCapacity = C.INITIAL_CAPACITY
        instructionsLabel.layer.cornerRadius = 60.0
        instructionsLabel.clipsToBounds = true


        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        setupHelp()
    }
    func setupHelp() {
        instLabelConst.constant = 1
        instructionsLabel.superview!.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.instLabelConst.constant = self.instructionsLabel.superview!.frame.width * 0.6
            self.instructionsLabel.superview!.layoutIfNeeded()
        }, completion: { complete in self.instructionsLabel.dropShadow(color: .black, opacity: 0.7, offSet: CGSize(width: 15, height: -15), radius: 6.0, scale: false)})
        switch mStatus {
        case 0:
        
            instructionsLabel.text = "The path to the exit is clear.  Robbie just needs to go forward 5 times and then turn right.  Drag the right turn into the 6th position on the instructions display"
            mFingerImage = UIImageView(image: UIImage(named: "finger"))
            mFingerImage?.frame.size = instImage1.frame.size
            mStart = instImage1.superview!.convert(instImage1.center, to: self.view)
            mFinish = tabview.superview!.convert(tabview.center, to: self.view)
            animateFinger()
            playButton.isEnabled = false
        case 1:
            instructionsLabel.text = "That's good.  Now try the insert control.  This will just add a 'go forward' instructions ahead of the instruction you select.  All other instructions will move down."
            mStart = insertImage.superview!.convert(insertImage.center, to: self.view)
        case 2:
            instructionsLabel.text = "You can delete a control by dragging it, but you can delete and cause all later instructions to move up by using the delete control. Try it now!"
            mStart = deleteImage.superview!.convert(deleteImage.center, to: self.view)
        case 3:
            instructionsLabel.text = "good job - now press the 'play' button to see whether you got it right"
            self.playButton.isEnabled = true
        default:
            break
        }
    }
    override  func updateTurn(indexPath: IndexPath, newAction: Action) {
        super.updateTurn(indexPath: indexPath, newAction: newAction)

        if mStatus == 0 && mTurns[5][0] == .right {
            mStatus = 1
            setupHelp()
        }
    }
    func animateFinger() {
        mFingerImage!.alpha = 1.0
        mFingerImage?.center = mStart!
        view.addSubview(mFingerImage!)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.mFingerImage?.center = self.mFinish!
            self.mFingerImage?.alpha = 0.1
        }, completion: { completed in
            self.mFingerImage?.removeFromSuperview()
            if self.mStatus < 3 {
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.animateFinger()
                }
            } else {
                self.mFingerImage = nil
            }
        })

    }
    override func play() {
        instructionsLabel.removeFromSuperview()
        super.play()
    }
    override func insertNopTurn(at indexPath : IndexPath) {
        if mStatus == 1 {
            mStatus = 2
            setupHelp()
        }
        super.insertNopTurn(at: indexPath)
    }
    override func deleteTurn(from indexPath: IndexPath) {
        if mStatus == 2 {
            mStatus = 3
            setupHelp()
        }
        super.deleteTurn(from: indexPath)
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
