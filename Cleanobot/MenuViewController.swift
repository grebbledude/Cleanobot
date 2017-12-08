//
//  MenuViewController.swift
//  Robots
//
//  Created by Pete Bennett on 23/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func pressTest(_ sender: Any) {
        performSegue(withIdentifier: "testSegue", sender: self)
    }
    @IBOutlet weak var textView: UITextField!
    @IBAction func pressPlay(_ sender: Any) {
        if room.text! == "1" {
            performSegue(withIdentifier: "initialPlay", sender: self)
        } else {
            
            performSegue(withIdentifier: "playSegue", sender: self)
        }
    }
    
    @IBOutlet weak var room: UITextField!
    @IBOutlet weak var floor: UITextField!
    @IBAction func pressSetup(_ sender: Any) {
        
        performSegue(withIdentifier: "setupSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? PlayController {
            dest.passData(floor: Int(floor.text!)!, room: Int(room.text!)!, happiness: 6, capacity: 6, health: 6)
        }
    }

}
