//
//  ListFloorTableController.swift
//  Robots
//
//  Created by Pete Bennett on 29/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
import SQLite

class ListFloorTableController: UITableViewController {
    var mParent: ListFloorController?
    
    var mRows: [RoomCell] = []
    var mTableRows = 0
    var mFloor = 1
    
    var mHealth = 0
    var mCapacity = 0
    var mHappiness = 0
/*    var nextRoom: Int {
        get {return mPare}
    } */

    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        getRows()
        self.tableView!.reloadData()
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let when = DispatchTime.now() + 0.1 
        mHappiness = C.INITIAL_HAPPINESS
        mHealth = C.INITIAL_HEALTH
        mCapacity = C.INITIAL_CAPACITY
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addRow()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getRows() {
        mRows=[]
        let dbt = DBTables()
        let rows = RoomTable.get(db: dbt, filter: RoomTable.FLOOR == mFloor, orderby: [RoomTable.ROOM])
        var health = C.INITIAL_HEALTH
        var capacity = C.INITIAL_CAPACITY
        var happiness = C.INITIAL_HAPPINESS
        var died = false
        for row in rows {
            health += row.health
            capacity += row.capacity
            happiness += row.happiness
            died = died || health <= 0 || capacity < 0 || happiness <= 0
            mRows.append(RoomCell(health: row.health, capacity: row.capacity, happiness: row.happiness))
            if died {
             break
            }

        }
        if !died {
            mRows.append(RoomCell(health: nil, capacity: nil, happiness: nil))
        }
        mParent!.nextRoom = mRows.count
    }
    func addRow() {
        if mTableRows < mRows.count {
            //           tableView.beginUpdates()
            let row = mRows[mTableRows]
            mTableRows += 1
            tableView.insertRows(at: [IndexPath(row: mTableRows - 1, section: 0)], with: .automatic)
            if let health  = row.health {
                mHealth += health
                mHappiness += row.happiness!
                mCapacity += row.capacity!
                mParent?.setValues(happiness: mHappiness, health: mHealth, capacity: mCapacity)
            }
 //           tableView.endUpdates()
   
            
            let when = DispatchTime.now() + 0.4 
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.addRow()
            }
        }
    }
    func listDir(level: Int) {
        let path = Bundle.main.resourceURL!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
            
            let xmlFileNames = xmlFiles.map{ $0.deletingPathExtension().lastPathComponent }
            let prefix = "board.\(level)."
            let count: Int = {
                var cnt = 0
                for name in xmlFileNames {
                    if name.hasPrefix(prefix) {
                        cnt += 1
                    }
                }
                return cnt
            }()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
 
    }
    func getStats(room: Int) -> RoomCell{

        var health = C.INITIAL_HEALTH
        var capacity = C.INITIAL_CAPACITY
        var happiness = C.INITIAL_HAPPINESS
        var i = 0
        while i < room - 1 {
            health += mRows[i].health!
            happiness += mRows[i].happiness!
            capacity += mRows[i].capacity!
            i += 1
        }
        return RoomCell(health: health, capacity: capacity, happiness: happiness)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mTableRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 10 {
            return tableView.dequeueReusableCell(withIdentifier: "complete", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "floor", for: indexPath) as! FloorTableCell
        let row = mRows[indexPath.row]
        cell.floorNumLabel.text = String(indexPath.row + 1)
        if let health = row.health {
            cell.healthLabel.text = String(health)
            cell.capacityLabel.text = String(row.capacity!)
            cell.happinessLabel.text = String(row.happiness!)
        } else {
            
            cell.healthLabel.text = "-"
            cell.capacityLabel.text = "-"
            cell.happinessLabel.text = "-"
        }

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= mParent!.nextRoom {
            mParent!.room = mParent!.nextRoom
        } else {
            mParent!.room = indexPath.row + 1
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func passData(parent: ListFloorController) {
        mParent = parent
    }

}
class FloorTableCell: UITableViewCell {
    
    @IBOutlet weak var floorNumLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var happinessLabel: UILabel!

    
}
