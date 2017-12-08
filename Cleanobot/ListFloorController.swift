//
//  LisFloorController.swift
//  Robots
//
//  Created by Pete Bennett on 29/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class ListFloorController: PortraitViewController {
    var mTableController: ListFloorTableController?

    @IBOutlet weak var powerNum: PowerView!
    @IBOutlet weak var healthNum: NumberView!
    @IBOutlet weak var capacityNum: NumberView!
    @IBOutlet weak var happinessNum: NumberView!
    @IBOutlet weak var playButton: UIButton!
    private var mFloor = 1
    private var mRoom = 1
    private var mFirstRoom = 0
    private var mNextRoom = 0
    var room : Int {
        set (setRoom) {selectedRoom(room: setRoom) }
        get {return mRoom}
    }
    var nextRoom: Int {
        set (setNextRoom) {
            mNextRoom = setNextRoom
            mRoom = mNextRoom
            if mNextRoom == 11 {
                playButton.titleLabel!.text = "Next Floor"
            }
        }
        get {return mNextRoom}
    }
    @IBAction func pressPlay(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 

        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationWillEnterForeground(_:)),
                                               name:.UIApplicationWillEnterForeground,
                                               object: nil)
     
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationDidEnterBackground(_:)),
                                               name:.UIApplicationDidEnterBackground,
                                               object: nil)
 
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        powerNum.stopTimer()
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {

        healthNum.value = C.INITIAL_HEALTH
        capacityNum.value = C.INITIAL_CAPACITY
        happinessNum.value = C.INITIAL_HAPPINESS
        powerNum.resetTimer()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        powerNum.resetTimer()
    }
    @objc func applicationDidEnterBackground(_ notification: NSNotification) {
        powerNum.stopTimer()
    }
    func setValues(happiness: Int, health: Int, capacity: Int) {
        
        healthNum.value = health
        capacityNum.value = capacity
        happinessNum.value = happiness
    }
    private func selectedRoom(room: Int) {
        mRoom = room
        
        if mNextRoom == room {
            if room == 10 {
                
                playButton.setTitle("Next  Floor", for: .normal)
            } else {
                
                playButton.setTitle("Next section \(nextRoom)", for: .normal)
            }
        } else {
            
            playButton.setTitle("Replay section \(mRoom)", for: .normal)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "embed" {
            mTableController = segue.destination as? ListFloorTableController
            mTableController?.passData(parent: self)
        } else {
            if segue.identifier == "play" {
                let play = segue.destination as! PlayController
                let stats = mTableController!.getStats(room: room)
                play.passData(floor: mFloor, room: mRoom, happiness: stats.happiness!, capacity: stats.capacity!, health: stats.health!)
                
            }
        }
    }
    

}
