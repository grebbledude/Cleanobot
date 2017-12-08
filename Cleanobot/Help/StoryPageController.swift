//
//  StoryPageController.swift
//  Robots
//
//  Created by Pete Bennett on 02/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class StoryPageController: UIPageViewController, UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    var mPages: [UIViewController?] = []
    var mNumPages = 3
    var mStartPage = 0
    weak var mParent: StoryController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        for _ in 0...mNumPages - 1 {
            mPages.append(nil)
        }
        setViewControllers([getPage(mStartPage)!], direction: .forward, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = getIndex(viewController)
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = currentIndex - 1
        return getPage(previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = getIndex( viewController)
        if currentIndex == mNumPages - 1 {
            mParent?.gotoFloor()
            return nil
        }
        let nextIndex = currentIndex + 1
        return getPage(nextIndex)
    }
    func getPage(_ index: Int) -> UIViewController? {
        if index < mPages.count {
            if let vc = mPages[index] {
                return vc
            } else {
                let storyboard = UIStoryboard(name: C.STORY_STORYBOARD, bundle: nil)
                
                let page = storyboard.instantiateViewController(withIdentifier: "Story\(index)")
                mPages[index] = page
                return page
            }
         } else {
            return nil
        }
    }
    func getIndex(_ vc: UIViewController) -> Int {
        for i in 0...mPages.count - 1 {
            if mPages[i] === vc {
                return i
            }
        }
        return 0 // never happens
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func passData(startPage: Int, numPages: Int, parent: StoryController) {
        mStartPage = startPage
        mNumPages = numPages
        mParent = parent
    }
    
}

