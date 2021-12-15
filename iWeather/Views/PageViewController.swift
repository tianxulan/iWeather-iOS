//
//  PageViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 12/5/21.
//

import UIKit
import SwiftSpinner
var globalFavoirteList:[FavoriteModel] = []


class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    
    var orderedViewControllers: [PageViewModel] = []
    let notification = Notification.Name(rawValue: K.favoriteNotificationKey)
    var pageControl = UIPageControl()

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        //Intilize orderViewControllers
        
        var homepageVC = self.newVc(viewController: "Homepage")
        orderedViewControllers.append(PageViewModel(VC: homepageVC, cityName: "Current"))
        
        
        // re added all view controller to page view contollers
        for (index,list) in globalFavoirteList.enumerated() {
            var addingVC = newVc(viewController: "FavoritePage") as! FavoritePageViewController
            addingVC.city = list.cityName
            // looking up session storage and setting model for favorite page VC
            orderedViewControllers.append(PageViewModel(VC:addingVC , cityName: list.cityName))
            
        }
        if let firstViewController = orderedViewControllers.first?.VC
        {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.delegate = self
        
        configurePageControl()
        createObservers()
            
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func createObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateViewControllers(notification:)), name: notification, object: nil)
        
    }
    @objc func updateViewControllers(notification: NSNotification)
    {
        if let dict = notification.userInfo as NSDictionary? {
                    if let operation = dict["operation"] as? String{
                        if let location = dict["location"] as? String{
                            if operation == "add"
                            {
                                
                                var addingVC = newVc(viewController: "FavoritePage") as! FavoritePageViewController
                                addingVC.city = location
                                // looking up session storage and setting model for favorite page VC
                                orderedViewControllers.append(PageViewModel(VC:addingVC , cityName: location))
                                pageControl.numberOfPages = orderedViewControllers.count
                                
                            }
                            else
                            {
                                
                                // looking up session storage and setting model for favorite page VC
                                var viewControllerIndex = 0;
                                for (index,item) in orderedViewControllers.enumerated()
                                {
                                    if item.cityName == location
                                    {
                                        viewControllerIndex = index
                                    }
                                }
                                orderedViewControllers.remove(at: viewControllerIndex)
                                pageControl.numberOfPages = orderedViewControllers.count
                            }
                        }
                        else
                        {
                            
                        }
                    }
            else{
                
            }
                }
        
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func configurePageControl()
    {
        pageControl = UIPageControl(frame:CGRect(x: 0, y: Int(UIScreen.main.bounds.maxY) - 80, width: K.screenWidth, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        var viewControllerIndex = 0;
        for (index,item) in orderedViewControllers.enumerated()
        {
            if item.VC === viewController
            {
                viewControllerIndex = index
            }
        }
        
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex].VC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        var viewControllerIndex = 0;
        for (index,item) in orderedViewControllers.enumerated()
        {
            if item.VC === viewController
            {
                viewControllerIndex = index
            }
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex].VC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        var viewControllerIndex = 0;
        for (index,item) in orderedViewControllers.enumerated()
        {
            if item.VC === pageContentViewController
            {
                viewControllerIndex = index
            }
        }
        self.pageControl.currentPage = viewControllerIndex
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
