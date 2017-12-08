//
//  SetupController.swift
//  Robots
//
//  Created by Pete Bennett on 25/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class SetupController: PortraitViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var roomText: UITextField!
    @IBOutlet weak var floorText: UITextField!
    @IBOutlet weak var instCount3: UITextField!
    @IBOutlet weak var instCount2: UITextField!
    @IBOutlet weak var instCount1: UITextField!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBAction func pressWrite(_ sender: Any) {
        doWrite()
    }
    @IBAction func pressRobot(_ sender: Any) {
        doRobot()
    }
    
    @IBAction func pressQuit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pressRead(_ sender: Any) {
        doRead()
    }
    @IBAction func pressFenceNone(_ sender: Any) {
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .none)

    }
    
    @IBAction func pressFenceNormal(_ sender: Any) {
        
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .normal)
    }
    
    @IBAction func pressElectric(_ sender: Any) {
        
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .electric)
    }
    @IBAction func pressDoorOpen(_ sender: Any) {
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .door, doorStatus: .open)
    }
    @IBAction func pressDoorClosed(_ sender: Any) {
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .door, doorStatus: .closed)
    }
    @IBAction func pressDoorOpening(_ sender: Any) {
        let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
        fence?.setFenceType(type: .door, doorStatus: .opening)
    }

    
    
    var mBoardController: BoardController?
    var COUNTS: [UITextField]!
    var mTurns: [[Action]]!
    var mCounts = [3,2,0,0,0,0]
    var mRobot = 0
    var mSetupRobot: SetupRobot?
    enum Modes: Int{
        case fences = 0
        case robots = 1
        case write = 2
        case read = 3
        case dismiss = 4
        case robotSelect = -1
    }
    var mCurrentMode: Modes = .fences
    var mSelectedRobot: RobotType = .rubbish
    let mRobots: [RobotType] = [.clear, .rubbish, .sweeper, .mouse, .ook]
    let mRobotsDescription = ["none","rubbish","sweeper","mouse", "ook"]
    
    @IBAction func modePressed(_ sender: Any) {


        let current = mCurrentMode.rawValue + 1
        mCurrentMode = Modes(rawValue: (current < 5 ? current : 0))!
        setButtons()
        let message: String = {
            switch mCurrentMode {
            case .fences:
                return "Fence mode"
            case .robots:
                return "Robot: Clear"
            case .write, .read:
                return "read/write level"
                
            case .robotSelect:
                return "Select Robot: Clear"
            case .dismiss:
                return "Dismiss"
            }
        }()
        _ = PopUpView(screen: self.view, message:  message)
    }

    
    @IBAction func firstPressed(_ sender: Any) {
        switch mCurrentMode {
        case .fences, .robots:
            mSetupRobot?.doMove()
            
        case .robotSelect:
            mSetupRobot?.addRobot(type: mSelectedRobot)
            
        case .dismiss:
            self.dismiss(animated: true, completion: nil)
        case .write:
                doWrite()

        case .read:
            doRead()

//        default:
//            break
        }
        
        
    }
    @IBAction func secondPressed(_ sender: Any) {
        switch mCurrentMode {
        case .fences, .robots:
            _ = mSetupRobot?.turnLeft()

        case .robotSelect:
            mSelectedRobot = RobotType(rawValue: (mSelectedRobot.rawValue >= C.ROBOT_TYPES.count - 1) ? 0 : (mSelectedRobot.rawValue + 1))!
            _ = PopUpView(screen: self.view, message: C.ROBOT_TYPES[mSelectedRobot.rawValue])
        default:
            break
        }
    }
    @IBAction func thirdPressed(_ sender: Any) {
        switch mCurrentMode {
        case .fences, .robots:
            _ = mSetupRobot?.turnRight()
  
        case .robotSelect:
            mSelectedRobot = RobotType(rawValue: (mSelectedRobot.rawValue == 0) ? 1 : (mSelectedRobot.rawValue - 1))!
            _ = PopUpView(screen: self.view, message: C.ROBOT_TYPES[mSelectedRobot.rawValue])
        default:
            break
        }
    }
    @IBAction func fourthPressed(_ sender: Any) {
        switch mCurrentMode {
        case .fences:
            let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
            if fence?.getType() == .electrified {
                fence?.setFenceType(type: .door)
            } else {
                if fence?.getType() == .electrified {
                    fence?.setFenceType(type: .none)
                } else {
                    fence?.setFenceType(type: .electric)
                }
            }

            
        case .robots:
            doRobot()
   //         mSetupRobot?.addRobot(type: mRobots[pickerView.selectedRow(inComponent: 0)])
//            mCurrentMode = .robotSelect
//            mSelectedRobot = .clear
//            _ = PopUpView(screen: self.view, message: "Currently clear")
        default:
            break
        }
    }
    @IBAction func fifthPressed(_ sender: Any) {
        switch mCurrentMode {
        case .fences:
            let fence  = mSetupRobot!.getPosition().getFence(in: (mSetupRobot?.getDirection())!)
            if fence?.getType() == .normal {
                fence?.setFenceType(type: .none)
            } else {
                fence?.setFenceType(type: .normal)
            }
        default:
            break
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        
        COUNTS = [instCount1,instCount2,instCount3]
        createBoard()
        
        mSetupRobot = SetupRobot(position: (mBoardController!.getBoard().getSquare(x: 0, y: 0)), direction: .right, board: mBoardController!.getBoard())
        mBoardController!.getBoard().addHouseRobot(robot: mSetupRobot!)
        setButtons()
        listDir()
        floorText.delegate = self
        roomText.delegate = self
        instCount1.delegate = self
        instCount2.delegate = self
        instCount3.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1 character numeric

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if string == numberFiltered {
            return true
        }
        
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func listDir() {
        let path = Bundle.main.resourceURL!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
            
            let xmlFileNames = xmlFiles.map{ $0.deletingPathExtension().lastPathComponent }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func floorValid() -> Bool {
        if let floor = (Int(floorText.text!)), let room = (Int(roomText.text!)) {
            return (floor > 0)  && (room > 0)
        }
        return false
    }
    func doWrite() {
        if floorValid() {
            getCounts()
            XMLCrawler.writeXML(board: mBoardController!.getBoard(), floor: Int(floorText.text!)!, room: Int(roomText.text!)!, instructions: mCounts)
            _ = PopUpView(screen: self.view, message: "Floor created")
        } else {
            _ = PopUpView(screen: self.view, message: "invalid values floor/room")
        }
        listDir()
    }
    func doRead() {
        createBoard()
        if floorValid() {
            mSetupRobot?.destroy(cause: .damage)
            setCounts(counts: XMLCrawler.readXML(board: mBoardController!.getBoard(), floor: Int(floorText.text!)!, room: Int(roomText.text!)!))
            
            mSetupRobot = SetupRobot(position: (mBoardController!.getBoard().getSquare(x: 0, y: 0)), direction: .right, board: mBoardController!.getBoard())
            _ = PopUpView(screen: self.view, message: "Floor created")
        } else {
            _ = PopUpView(screen: self.view, message: "invalid values floor/room")
        }
    }
    func doRobot() {
        mSetupRobot?.addRobot(type: mRobots[pickerView.selectedRow(inComponent: 0)])
    }
    func setButtons() {
        switch mCurrentMode {
        case .fences:
            playButton.titleLabel?.text = ">"
            secondButton.titleLabel?.text = "^"
            thirdButton.titleLabel?.text = "v"
            fourthButton.titleLabel?.text = "e"
            fifthButton.titleLabel?.text = "n"
            modeButton.titleLabel?.text = "#"
        case .write:
            playButton.titleLabel?.text = "W"
            secondButton.titleLabel?.text = " "
            thirdButton.titleLabel?.text = " "
            fourthButton.titleLabel?.text = " "
            fifthButton.titleLabel?.text = ""
            modeButton.titleLabel?.text = "#"
        case .read:
            playButton.titleLabel?.text = "R"
            secondButton.titleLabel?.text = " "
            thirdButton.titleLabel?.text = " "
            fourthButton.titleLabel?.text = " "
            fifthButton.titleLabel?.text = ""
            modeButton.titleLabel?.text = "#"
        case .robots:
            playButton.titleLabel?.text = ">"
            secondButton.titleLabel?.text = "^"
            thirdButton.titleLabel?.text = "v"
            fourthButton.titleLabel?.text = "r"
            fifthButton.titleLabel?.text = ""
            modeButton.titleLabel?.text = "#"
        case .robotSelect:
            playButton.titleLabel?.text = ">"
            secondButton.titleLabel?.text = "^"
            thirdButton.titleLabel?.text = "v"
            fourthButton.titleLabel?.text = ""
            fifthButton.titleLabel?.text = ""
            modeButton.titleLabel?.text = "#"
        case .dismiss:
            playButton.titleLabel?.text = ">"
            secondButton.titleLabel?.text = " "
            thirdButton.titleLabel?.text = " "
            fourthButton.titleLabel?.text = " "
            fifthButton.titleLabel?.text = " "
            modeButton.titleLabel?.text = "#"
        
        }
    }
    func createBoard() {
        mTurns = [[],[],[],[],[]]
        mCounts = [3,2,0,]
        for i in 0...2 {
            COUNTS[i].text = String(mCounts[i])
        }
        _ = mBoardController!.getNewBoard()
    }
    //MARK: Callbacks from board

      func setAction(action: Action, row: Int) {
        
    }
    private func setCounts(counts: [Int]) {
        mCounts = counts
        for i in 0...2 {
            COUNTS[i].text = String(mCounts[i])
        }
    }
    private func getCounts() {
        for i in 0...2 {
            mCounts[i] = Int(COUNTS[i].text!)!
        }
    }
    //MARK: Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mRobots.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mRobotsDescription[row]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "board" {  // embedded
            mBoardController = segue.destination as? BoardController
            mBoardController!.passData(source: self)
            //            xxx
        }
        
    }
}
