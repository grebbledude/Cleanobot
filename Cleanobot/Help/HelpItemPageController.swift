//
//  HelpItemPageController.swift
//  Robots
//
//  Created by Pete Bennett on 14/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class HelpItemPageController: UIPageViewController, UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    var mPages: [UIViewController] = []
    var mNumPages: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        for i in 0...mNumPages - 1 {
            mPages.append(getPage(i))
        }
        setViewControllers([mPages[0]], direction: .forward, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let currentIndex = mPages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = currentIndex - 1
        return mPages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = mPages.index(of: viewController)!
        if currentIndex == mNumPages - 1 {
            return nil
        }
        let nextIndex = currentIndex + 1
        return mPages[nextIndex]
    }
    func getPage(_ index: Int) -> UIViewController {
        if index < mPages.count {
            return mPages[index]
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            var page: UIViewController
            switch index {
            case 0:
                page = storyboard.instantiateViewController(withIdentifier: "wallHelp")
            case 1:
                page = storyboard.instantiateViewController(withIdentifier: "electricWallHelp")
            default:
                return UIViewController() // never happens
            }
            mPages.append(page)
            return page
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
    func passData(pages: Int) {
        mNumPages = pages
    }

}
