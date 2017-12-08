//
//  TestViewController.swift
//  Cleanobot
//
//  Created by Pete Bennett on 10/11/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 15, height: -15), radius: 6.0, scale: true)

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
