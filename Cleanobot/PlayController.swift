//
//  PlayController.swift
//  Robots
//
//  Created by Pete Bennett on 23/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class PlayController: PortraitViewController, UITableViewDelegate, UITableViewDataSource, PlayDelegate {
    
    //TODO - prevent click on no entry instructables
    
    @IBOutlet weak var quitButton: UIButton!
    
    @IBAction func pressReset(_ sender: Any) {
        if mCurrentlyPlaying {  // Can't do anything mid play.
            return
        }
        for i in 0...mTurns.count - 1 {
            for j in 0...mTurns[i].count - 1 {
                if mTurns[i][j] != .nop {
                    mCounts[mTurns[i][j].rawValue] += 1
                    mTurns[i][j] = .nop
                }
            }
        }
        tabview.reloadData()
        COUNTS[0].text! = String(mCounts[0])
        COUNTS[1].text! = String(mCounts[1])
        COUNTS[2].text! = String(mCounts[2])
    }

    @IBOutlet weak var power1View: PowerView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var healthNum: NumberView!
    var powerNum: PowerView {
        get {return power1View}
    }
    @IBOutlet weak var capacityNum: NumberView!
    @IBOutlet weak var happinessNum: NumberView!

    @IBAction func pressRobot(_ sender: UIButton) {
        if mCurrentlyPlaying {  // Everything locked mid play
            return
        }
        for i in 0...4 {
            
            if sender === ROBOT_BUTTONS[i] {
                selectRobot(number: i)
                return
                
            }
        }
    }
    @IBAction func pressDismiss(_ sender: UIButton) {
        if !mCurrentlyPlaying {
            goBack()
        }
    }
    @IBAction func dragTable(_ sender: UILongPressGestureRecognizer) {
        if mCurrentlyPlaying { // Locked mid play
            return
        }
        dragFromTable(sender)
    }
    @IBAction func firstPressed(_ sender: Any) {
        if mCurrentlyPlaying {  // already playing so ignore
            return
        }
        TurnsXML.write(turns: mTurns, floor: mFloor, room: mRoom)
        if reducePower(by: 1) {
            playButton.isEnabled = false
            play()
        }

 
        
        
    }
    @IBOutlet weak var heartImage: FlashImageView!
    

    @IBOutlet weak var binImage: FlashImageView!
    @IBOutlet weak var boltImage: FlashImageView!

    @IBOutlet weak var happinessImage: FlashImageView!
    
    @IBOutlet weak var modeButton: UIButton!

    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var selRobot1: UIButton!
    @IBOutlet weak var selRobot2: UIButton!
    @IBOutlet weak var selRobot3: UIButton!
    @IBOutlet weak var selRobot4: UIButton!
    @IBOutlet weak var selRobot5: UIButton!
    @IBAction func selectInst(_ sender: UIGestureRecognizer) {
        if mCurrentlyPlaying {  // Lock screen mid play
            return
        }
        draggingNew(sender)
    }
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var insertImage: UIImageView!
    @IBOutlet weak var instImage1: UIImageView!
    @IBOutlet weak var instImage2: UIImageView!
    @IBOutlet weak var instImage3: UIImageView!
   
    @IBOutlet weak var instCount1: UILabel!
    @IBOutlet weak var instCount2: UILabel!
    @IBOutlet weak var instCount3: UILabel!

    @IBOutlet weak var tabview: UITableView!
    
    let ACTION_IMAGES = ["rightImage", "leftImage","activateImage","insertimage","deleteimage","xxx"]
    var IMAGES: [UIImageView]!
    var COUNTS: [UILabel]!
    var ROBOT_BUTTONS: [UIButton]!
    var mDragNo = -1
    var mDragView: UIView?
    var mTurns: [[Action]]!
    var mCurrentlyPlaying = false
    
    var mTotalTurns = C.TOTAL_TURNS
    var mCounts = [0,0,0]
    
    var mRobot = 0
    var mOrigIndexPath: IndexPath?


    var mCurrentTurn = 0
    
    var mInstructableCount = 0
    
    var mFinished = false
    var mBoardController: BoardController?

    var mFloor = 1
    var mRoom = 1
    var mHappiness = 0
    var mHealth = 0
    var mCapacity = 0
    var mOrigCapacity = 0
    var mOrigHealth = 0
    var mOrigHappiness = 0
    var mFinalHealth = 0
    
    var mCauseOfDeath: CauseOfDeath? = nil
  
    // var mFirstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tabview.delegate = self
        tabview.dataSource = self
        IMAGES = [instImage1, instImage2, instImage3, insertImage, deleteImage]
        COUNTS = [instCount1,instCount2,instCount3]
        ROBOT_BUTTONS = [selRobot1,selRobot2,selRobot3,selRobot4,selRobot5]
        
        resetBoard()
  
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationWillEnterForeground(_:)),
                                               name:.UIApplicationWillEnterForeground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationDidEnterBackground(_:)),
                                               name:.UIApplicationDidEnterBackground,
                                               object: nil)
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        powerNum.resetTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        powerNum.stopTimer()
    }


    override func viewDidLayoutSubviews() {
        

        super.viewDidLayoutSubviews()
        mBoardController?.getBoard().layoutRobots()

    }
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        powerNum.resetTimer()
    }
    @objc func applicationDidEnterBackground(_ notification: NSNotification) {
        powerNum.stopTimer()
    }
    func resetBoard() {
        mInstructableCount = 0
        mFinished = false
        playButton.isEnabled = true

        initialiseTurns()

        var counts = XMLCrawler.readXML(board: mBoardController!.getNewBoard(), floor: mFloor, room: mRoom)

        mBoardController!.getBoard().setup()
        happinessNum.value = mHappiness
        healthNum.value = mHealth
        capacityNum.value = mCapacity
        if let turns = TurnsXML.read(floor: mFloor, room: mRoom) {
            mTurns = turns
            for turn in turns {
                for action in turn {
                    if action != .nop {
                        counts[action.rawValue] -= 1
                    }
                }
            }
        }
        setCounts(counts: counts)
 /*       mBoardController?.getBoard().removeConstraints()
        print (mBoardController!.getBoardStack().constraints)
        for constraint in mBoardController!.getBoardStack().constraints {
            if let id = constraint.identifier {
                print ("Cosntraint \(id)")
            }
        }
        let x = 1 */
    }
    func play() {
        mCurrentlyPlaying = true
        self.mBoardController!.getBoard().initaliseActions(turns: self.mTurns)
        self.mCurrentTurn = 0
        self.mFinished = false
        self.mCauseOfDeath = nil
        
        self.tabview.scrollToRow(at: IndexPath( row: 0, section: 0), at: .top, animated: true)
        self.tabview.setNeedsDisplay()
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.mBoardController!.getBoard().doTurn()
        }
        
    }
    func goBack() {
        let defaults = UserDefaults.standard
        let maxPage = defaults.integer(forKey: C.MAXPAGE)
        let startPage = defaults.integer(forKey: C.STARTPAGE)
        if maxPage > startPage {
            self.performSegue(withIdentifier: "story", sender: self)
        } else {
            self.performSegue(withIdentifier: "floor", sender: self)
        }
            
    }
    func initialiseTurns() {
        
        mTurns = Array.init(repeating: [], count: mTotalTurns)
    }
    private func setCounts(counts: [Int]) {
        mCounts = counts
        for i in 0...2 {
            COUNTS[i].text = String(mCounts[i])
        }
    }
    func updateStats() {

        let health = mFinalHealth - mOrigHealth
        let capacity = mCapacity - mOrigCapacity
        let happiness = mHappiness - mOrigHappiness
        let dbt = DBTables()
        if let room = RoomTable.getKey(db: dbt, id: "room.\(mFloor).\(mRoom)") {
            room.health = health
            room.capacity = capacity
            room.happiness = happiness
            room.update(db: dbt)
        } else {
            let room = RoomTable()
            room.health = health
            room.capacity = capacity
            room.happiness = happiness
            room.floor = mFloor
            room.room = mRoom
            room.id = "room.\(mFloor).\(mRoom)"
            _ = room.insert(db: dbt)
        }
    }
    //MARK: Callbacks from board
    func setInstructable(index: Int, image: String) {
        ROBOT_BUTTONS[index].isEnabled = true
        ROBOT_BUTTONS[index].setImage(UIImage(named: image), for: .normal)
        mInstructableCount = index + 1
        for i in 0...mTotalTurns - 1 {
            mTurns[i].append(.nop)
        }
        
    }

    func setTotalTurns(turns: Int) {
        mTotalTurns = turns
        mTurns = Array.init(repeating: [], count: mTotalTurns)
    }
    func finishedTurn() {
        mCurrentTurn += 1
        if mCurrentTurn >= mTotalTurns {
            _ = PopUpView(screen: view, message: "You ran out of time")
            reduceHealth(by: 999, cause: .timeout) // Kill
            mFinished = true
        }
        if !mFinished {
            tabview.scrollToRow(at: IndexPath( row: mCurrentTurn, section: 0), at: .top, animated: true)
            mBoardController!.getBoard().doTurn()
        } else {
            FinishedImageView.createView(view: (mBoardController?.getBoardStack())!, cause: mCauseOfDeath!, completion: chooseNextAction)
        }
      }

    func chooseNextAction() {
        updateStats()
        let alert = UIAlertController(title: "complete", message: "what now?", preferredStyle: .alert)
        var action = UIAlertAction(title: "Replay", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.mHealth = self.mOrigHealth
            self.mHappiness = self.mOrigHappiness
            self.mCapacity = self.mOrigCapacity
            self.resetBoard()
            self.play()
        })
        alert.addAction(action)
    
        action = UIAlertAction(title: "Slow Motion", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.mHealth = self.mOrigHealth
            self.mHappiness = self.mOrigHappiness
            self.mCapacity = self.mOrigCapacity
            self.resetBoard()
            self.mBoardController!.getBoard().setSpeed(to: 0.8)
            self.play()
            
            
        })
        alert.addAction(action)
        action = UIAlertAction(title: "Try Again", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.mHealth = self.mOrigHealth
            self.mFinalHealth = self.mHealth
            self.mHappiness = self.mOrigHappiness
            self.mCapacity = self.mOrigCapacity
            self.resetBoard()
            self.mCurrentlyPlaying = false
            
        })
        alert.addAction(action)
        action = UIAlertAction(title: "Next", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.goBack()
            
        })
    
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func nextInstructable(index: Int) {
        if index <= mInstructableCount {
            let cell = tabview.cellForRow(at: IndexPath(row: mCurrentTurn, section: 0 )) as? TurnCell
            cell?.flash(index: index)
        }
    }
    func reduceHealth(by delta: Int, cause: CauseOfDeath) {
        mCauseOfDeath = cause
        mHealth -= delta
        mFinalHealth = mHealth
        if mHealth <= 0 {
            mHealth = 0
            mFinished = true
        }
        healthNum.value = mHealth
        heartImage.flashImage()
    }
    func reduceCapacity(by delta: Int) {
        mCapacity -= delta
        if mCapacity < 0 {
            mCapacity = -1
            mFinished = true
            mCauseOfDeath = .capacityExceeded
        }
        capacityNum.value = mCapacity
        binImage.flashImage()
    }
    func reducePower(by delta: Int) -> Bool {
        let power =  powerNum.value - delta
        if power < 0 {
            return false
        }

        powerNum.value = power
   
        boltImage.flashImage()
        return true
    }
    func reduceHappiness(by delta: Int) {
        mHappiness -= delta
        happinessNum.value = mHappiness
        happinessImage.flashImage()
    }
    func getHappiness() -> Int {
        return mHappiness
    }
    func foundDoor(rubbish: Int) -> Bool {
        if rubbish >= mHappiness {
            _ = PopUpView(screen: view, message: "Room too messy!")
            return false
        } else {
            mHappiness -= rubbish
            mFinished = true
            mCauseOfDeath = .survived
            _ = PopUpView(screen: view, message: "Finished!!")
            let defaults = UserDefaults.standard
            let  maxStory = defaults.integer(forKey: C.MAXPAGE)
            let newMax = mBoardController!.getBoard().maxStory
            if  newMax > maxStory {
                defaults.set(newMax, forKey: C.MAXPAGE)
            }
            return true
        }
    }


    //MARK: drag and drop
    func selectRobot(number: Int) {
        mRobot = number
        for cell in tabview.visibleCells as! [TurnCell] {
            cell.setRobot(robot: number)
        }
        
    }
    func dragFromTable(_ sender: UIGestureRecognizer) {
        
        let locationInView = sender.location(in: view)
        let locationInTableView = sender.location(in: tabview)
        let indexPath = tabview.indexPathForRow(at: locationInTableView)
        switch sender.state {
        case .began:
            if indexPath == nil {
                sender.cancel()
                return
            }
            if mTurns[indexPath!.row][mRobot] == .nop {
                sender.cancel()
                return
            }
            mOrigIndexPath = indexPath
            mDragNo = mTurns[indexPath!.row][mRobot].rawValue
            mDragView = copyImage(inputView: IMAGES[mDragNo])
            let imageFrame = CGRect(origin: CGPoint.zero, size: IMAGES[mDragNo].frame.size)
            mDragView?.frame = imageFrame
            mDragView?.center = locationInView
            view.addSubview(mDragView!)
        case .changed:
            mDragView?.center = locationInView
        case .ended:
            
            let tableLocation = sender.location(in: tabview)
            let indexPath = tabview.indexPathForRow(at: tableLocation)
            mDragView?.removeFromSuperview()
 
            if indexPath != nil {
                if indexPath!.row == mOrigIndexPath!.row {
                    return
                } // if we dragged back to where it started, then do nothing.
            }
            /*
                if let _ = tabview.cellForRow(at: indexPath!) {
                    updateTurn(indexPath: indexPath!, newAction: Action(rawValue: mDragNo)!)
                } else {
                    print("missed")
                }
            } */
            // This code worked, but isn't very friendly.  Too easy to drop in the wrong place.
            
            updateTurn(indexPath: mOrigIndexPath!, newAction: .nop)
            
        case .cancelled, .failed:
            mDragView?.removeFromSuperview()
        default:
            break
        }
        
    }
    func draggingNew(_ sender: UIGestureRecognizer) {
        let locationInView = sender.location(in: view)
        switch sender.state {
        case .began:
            let initial = sender.location(in: self.view)
            mDragNo = -1
            for i in 0...5 {
                let imageFrame = IMAGES[i].convert(IMAGES[i].frame, to: nil)
                if imageFrame.contains(initial) {
                    if i < 3 && mCounts[i] == 0 {  // no counts for 4th and 5th actions
                        mDragNo = -1
                        sender.cancel()
                        break
                    }
                    mDragNo = i
                    mDragView = copyImage(inputView: IMAGES[mDragNo])
                    mDragView?.frame = imageFrame
                    view.addSubview(mDragView!)
                    break
                }
            }
        case .changed:
            mDragView?.center = locationInView
        case .ended:
            
            let tableLocation = sender.location(in: tabview)
            let indexPath = tabview.indexPathForRow(at: tableLocation)
            mDragView?.removeFromSuperview()
            if indexPath != nil {
                updateTurn(indexPath: indexPath!, newAction: Action(rawValue: mDragNo)!)
            }
        case .cancelled, .failed:
            mDragView?.removeFromSuperview()
        default:
            break
        }
    }
    func updateTurn(indexPath: IndexPath, newAction: Action) {
        if newAction == .insert {
            insertNopTurn(at: indexPath)
            return
        } else {
            if newAction == .delete {
                deleteTurn(from: indexPath)
                return
            }
        }
        let prevAction = mTurns[indexPath.row][mRobot]
        if prevAction != .nop {
            mCounts[prevAction.rawValue] += 1
        }
        mTurns[indexPath.row][mRobot] = newAction
        if newAction != .nop {
            mCounts[newAction.rawValue] -= 1
        }
        
        if mDragNo == -1 {
            
        }
        for i in 0...2 {
            COUNTS[i].text = String(mCounts[i])
        }
        if let cell = tabview.cellForRow(at: indexPath) as? TurnCell { // may have disappeared off screen
            cell.draw(turns: mTurns, row: indexPath.row, images: ACTION_IMAGES, instructables: mInstructableCount)
        }
    }
    func insertNopTurn(at indexPath : IndexPath) {
        let row = indexPath.row
        let last = mTurns[mTotalTurns - 1][mRobot].rawValue
        if last >= 0 {
            mCounts[last] += 1
            COUNTS[last].text = String(mCounts[last])
        }
        if row < mTotalTurns - 1 {
            for i in (((row + 1)...mTotalTurns - 1)).reversed() {
                mTurns[i][mRobot]  = mTurns[i - 1][mRobot]
                redrawCell(row: i)
            }
        }
        
        mTurns[row][mRobot] = .nop
        redrawCell(row: row)
    }
    func deleteTurn (from indexPath: IndexPath) {
        let row = indexPath.row
        let deleted = mTurns[row][mRobot].rawValue
        if deleted >= 0 {
            mCounts[deleted] += 1
            COUNTS[deleted].text = String(mCounts[deleted])
        }
        if row < mTotalTurns - 1 {
            for i in ((row...mTotalTurns - 2)) {
                mTurns[i][mRobot]  = mTurns[i + 1][mRobot]
                redrawCell(row: i)
            }
        }
        mTurns[mTotalTurns - 1][mRobot] = .nop
        redrawCell(row: mTotalTurns - 1)
    }
    func redrawCell(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = tabview.cellForRow(at: indexPath) as? TurnCell { // may have disappeared off screen
            cell.draw(turns: mTurns, row: row, images: ACTION_IMAGES, instructables: mInstructableCount)
        }
    }
    func copyImage(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let copy = UIImageView(image: image)
        copy.layer.masksToBounds = false
        copy.layer.cornerRadius = 0.0
        copy.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        copy.layer.shadowRadius = 5.0
        copy.layer.shadowOpacity = 0.4
        return copy
    }
    func setAction(action: Action, row: Int) {
        
    }
    //MARK: Table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //    func tableview(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTotalTurns
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "turn", for: indexPath) as! TurnCell
        cell.setRobot(robot: mRobot)
        cell.draw(turns: mTurns, row: indexPath.row, images: ACTION_IMAGES,instructables: mInstructableCount)
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "board" {
            mBoardController = segue.destination as? BoardController
            mBoardController!.passData(source: self)
        }
        
        
    }
    func passData(floor: Int, room: Int, happiness: Int, capacity: Int, health: Int) {
        mFloor = floor
        mRoom = room
        mHealth = health
        mFinalHealth = health
        mOrigHealth = health
        mHappiness = happiness
        mOrigHappiness = happiness
        mCapacity = capacity
        mOrigCapacity = capacity
    }
    
    static func adjustPower (delta : Int ) -> Int{
        
        var power = getPower()
        power += delta
        
        let defaults = UserDefaults.standard
        defaults.set(power, forKey: "power")
        return power
    }
    static func getPower() -> Int {
        let defaults = UserDefaults.standard
        
        var power = defaults.integer(forKey: "power")
        if power == C.INITIAL_POWER {
            let timestamp = Date().timeIntervalSinceReferenceDate
            defaults.set(timestamp, forKey: "lastConsume")
        } else {
            let oldTimestamp = defaults.double(forKey: "lastConsume")
            let timeDelta = ( Date().timeIntervalSinceReferenceDate - oldTimestamp ) / Double( C.POWER_REGEN * 60 )
            power += Int(timeDelta)
            
            let timestamp = Date().timeIntervalSinceReferenceDate
            defaults.set(timestamp, forKey: "lastConsume")
            defaults.set(power, forKey: "power")
            
        }
        return power
    }
    
    

}
class TurnCell: UITableViewCell {
    
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var turnMe1: FlashImageView!
    @IBOutlet weak var turnMe2: FlashImageView!
    @IBOutlet weak var turnMe3: FlashImageView!
    @IBOutlet weak var turnMe4: FlashImageView!
    @IBOutlet weak var turnMe5: FlashImageView!
 
    var mRobot = 0
    func setRobot(robot: Int) {
        mRobot = robot
        let listImages = [turnMe1,turnMe2,turnMe3,turnMe4, turnMe5]
        for i in 0...4 {
            listImages[i]?.backgroundColor = (mRobot == i) ? .green : .clear
        }
    }
    func draw (turns: [[Action]], row: Int, images: [String], instructables: Int){

        let listImages = [turnMe1,turnMe2,turnMe3,turnMe4, turnMe5]
        for i in 0...4 {
            if i >= instructables {
                listImages[i]?.image = UIImage()
            } else {
                if turns[row][i] == .nop {
                    listImages[i]?.image = UIImage(named: "forward")
                } else {
                    listImages[i]?.image = UIImage(named: images[turns[row][i].rawValue])
                }
            }
            
        }
        turnLabel.text = String(row + 1)
    }
    func flash(index: Int) {
        let listImages = [turnMe1,turnMe2,turnMe3,turnMe4, turnMe5]
        listImages[index]?.flashImage()
    }
    
}
