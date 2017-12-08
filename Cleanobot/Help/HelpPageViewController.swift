//
//  HelpPageViewController.swift
//  Robots
//
//  Created by Pete Bennett on 21/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit

class HelpPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var mPages: [UIViewController?] = []
    var mNumPages = 2
    var mCurrentPage = 0
    weak var mParent: HelpViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        mPages = Array.init(repeating: nil, count: mNumPages)
        
        setViewControllers([getPage(0)!], direction: .forward, animated: true, completion: nil)

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
            return nil
        }
        let nextIndex = currentIndex + 1
        return getPage(nextIndex)
    }
    func getIndex(_ vc: UIViewController) -> Int {
        for i in 0...mPages.count - 1 {
            if mPages[i] === vc {
                return i
            }
        }
        return 0 // never happens
    }
    func getPage(_ index: Int) -> UIViewController? {
        if index < mPages.count {
            if let vc = mPages[index] {
                return vc
            } else {
                mPages[index] = mParent!.getPage(index: index)
                return mPages[index]
            }
        } else {
            return nil
        }
    }
    func showPage(pageNum: Int) {
        
        if pageNum == mCurrentPage {
            return //  no change on page number
        }
        mCurrentPage = pageNum
        setViewControllers([getPage(pageNum)!], direction: .forward, animated: true, completion: nil)
    }
    func passData(parent: HelpViewController, pages: Int) {
        mParent = parent
        mNumPages = pages
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
