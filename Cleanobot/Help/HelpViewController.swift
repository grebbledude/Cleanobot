//
//  HelpViewController.swift
//  Robots
//
//  Created by Pete Bennett on 20/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class HelpViewController: PortraitViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func pressBack(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var tabView: UITableView!
    enum HelpPages: String {
        case ship
        case fence
        case electricfence
        case cleanobot
        case mouse
        case sweeper
        case rubbish
        case killerrobot
        case program
        case ook
        case controls
    }
    let mImages: [HelpPages : String] = [.cleanobot : "robbieSmall", .sweeper : "sweeperImage", .mouse: "GreyMouse", .ook: "ookGreen", .controls: "insertImage", .rubbish: "rubbishImage", .ship: "spaceship"]
    var mSection = 1
    var mExpanded = [false, false, false]
    weak var mEmbedPageController: HelpPageViewController?
    let mContents: [[HelpPages]] = [[.controls, .ship, .ook],[.program, .cleanobot, .mouse], [.fence, .electricfence, .rubbish, .killerrobot, .sweeper]]
    var mTotalItems: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabView!.dataSource = self
        tabView!.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mContents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mExpanded[section] ? mContents[section].count + 1 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! HelpHeaderTableCell
            cell.contentLabel.text = {
                
                let prefix = mExpanded[indexPath.section] ? "collapse" : "expand"
                switch indexPath.section {
                case 0:
                    setImage(name: prefix + "Brown", image: cell.helpImage)
                    return "Environment"
                case 1:
                    setImage(name: prefix + "Blue", image: cell.helpImage)
                    return "Programmable Robots"
                default: // = 2
                    setImage(name: prefix + "DarkBlue", image: cell.helpImage)
                    return "Obstacles and Killer Robots"
                }
            }()
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! HelpDetailTableCell
            cell.contentLabel.text = getDescription(indexPath: indexPath)
            if let imageName = mImages[mContents[indexPath.section][indexPath.row - 1]] {
                cell.helpImage.image = UIImage(named: imageName)
            } else {
                cell.helpImage.image = nil
            }
            cell.backgroundColor = {
                switch indexPath.section {
                case 0:
                    return UIColor.brown
                case 1:
                    return UIColor.cyan
                default:
                    return UIColor.blue
                }
            }()
            return cell
        }

    }
    func setImage(name: String, image: UIImageView) {
        image.image = UIImage(named: name)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            mExpanded[indexPath.section] = !mExpanded[indexPath.section]
            tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .bottom)
        } else {
            var pageNum = indexPath.row - 1
            var section = indexPath.section
            while section > 0 {
                section -= 1
                pageNum += mContents[section].count
            }
            mEmbedPageController?.showPage(pageNum: pageNum)
        }
        
    }
    func getDescription(indexPath: IndexPath) -> String {
        let item = mContents[indexPath.section][indexPath.row - 1]
        switch item {
        case .cleanobot:
            return "Cleanobot"
        case .fence:
            return "Wall"
        case .electricfence:
            return "Electrified Wall"
        case .killerrobot:
            return "Killer Robots"
        case .mouse:
            return "Toy Mouse"
        case .sweeper:
            return "Sweeper"
        case .ship:
            return "Ook ship"
        case .rubbish:
            return "Rubbish"
        case .program:
            return "Programmable robots"
        case .ook:
            return "Ooks"
        case .controls:
            return "Controls"
        }
    }
    func getPage(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: C.STORY_STORYBOARD, bundle: nil)
        var section = 0
        var pageNum = index
        while pageNum >= mContents[section].count {
            pageNum -= mContents[section].count
            section += 1
        }
        let page = storyboard.instantiateViewController(withIdentifier: mContents[section][pageNum].rawValue)
        return page
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "embed" {
            mTotalItems = mContents[0].count + mContents[1].count + mContents[2].count
            let vc = segue.destination as! HelpPageViewController
            mEmbedPageController = vc
            vc.passData(parent: self, pages: mTotalItems)
        }
    }
    

}
class HelpHeaderTableCell: UITableViewCell {
    
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
}
class HelpDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
}
