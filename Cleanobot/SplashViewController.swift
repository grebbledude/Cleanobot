//
//  SplashViewController.swift
//  Robots
//
//  Created by Pete Bennett on 30/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var ookView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var splashView: SplashToaster!
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topConstraint.constant = self.view.frame.size.height / 2.0
        leadingConstraint.constant = -self.view.frame.size.height / 2.0
        view.layoutIfNeeded()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.0, animations: {
            self.leadingConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: {
            complete in self.splashView.makeToast()
            UIView.animate(withDuration: 1.0, delay: 4.0, options: [], animations: {
                self.ookView.alpha = 0.0
            }, completion: nil)
            
        })
        let when = DispatchTime.now() + 7.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            let defaults = UserDefaults.standard
            
            let doFloor = defaults.bool(forKey: "storyPlayed")
            if doFloor {
                self.performSegue(withIdentifier: "floor", sender: self)
            } else {
                self.performSegue(withIdentifier: "story", sender: self)
                defaults.set(true, forKey: "storyPlayed")

            }
        }
       // splashView.makeToast()
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return .landscapeLeft
        }
    }
/*    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    } */
    
    open override var shouldAutorotate: Bool {
        get {
            return true}

    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .landscape
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    

}
