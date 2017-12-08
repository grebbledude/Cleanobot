//
//  WallEmbedController.swift
//  Robots
//
//  Created by Pete Bennett on 12/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class WallEmbedController: UIViewController {

    @IBOutlet weak var wallView: FenceView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let initV = wallView.initialValue
        let fencePos = FencePosition(type: initV, directions: [:])
        wallView.setFence(fence: fencePos.fence, direction: .right)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
