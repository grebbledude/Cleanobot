//
//  StoryController.swift
//  Robots
//
//  Created by Pete Bennett on 02/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class StoryController: PortraitViewController {
    var mMaxPage = 0
    var mStartPage = 0

    @IBAction func pressSkip(_ sender: Any) {
        gotoFloor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let defaults = UserDefaults.standard
        mMaxPage = defaults.integer(forKey: C.MAXPAGE)
        
        if let vc = segue.destination as? StoryPageController {
            let defaults = UserDefaults.standard
            mStartPage = defaults.integer(forKey: C.STARTPAGE)
            if mStartPage >= mMaxPage {
                mStartPage = mMaxPage
            }
            vc.passData(startPage: mStartPage, numPages: mMaxPage + 1, parent: self)

        }
    }
    func gotoFloor() {
        
        let defaults = UserDefaults.standard
        defaults.set(mMaxPage + 1, forKey: C.STARTPAGE)
        if mStartPage == 0 {
            performSegue(withIdentifier: "initial", sender: self)
        } else {
            performSegue(withIdentifier: "floor", sender: self)
        }
    }
    

}
