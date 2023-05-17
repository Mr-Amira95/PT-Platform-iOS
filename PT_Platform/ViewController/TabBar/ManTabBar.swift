//
//  ManTabBar.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/01/2022.
//

import UIKit
import LanguageManager_iOS

class ManTabBar: UITabBarController, UITabBarControllerDelegate {
    
    var rootVC: RootVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            tabBar.items?[0].title = "Home"
            tabBar.items?[1].title = "Coach"
            tabBar.items?[2].title = "Profile"
        }else{
            tabBar.items?[0].title = "القائمة الرئيسية"
            tabBar.items?[1].title = "المدرب"
            tabBar.items?[2].title = "الملف الشخصي"
        }
        navigationItem.largeTitleDisplayMode = .automatic
        self.delegate = self
        rootVC = RootVC()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomePageCoachVC), name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
    }
    
    @objc func reloadHomePageCoachVC() {
        self.selectedIndex = 1
        }
    
    override var selectedIndex: Int { // Mark 1
           didSet {
               guard let selectedViewController = viewControllers?[selectedIndex] else {
                   return
               }
               selectedViewController.tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
           }
       }

       override var selectedViewController: UIViewController? { // Mark 2
           didSet {
               guard let viewControllers = viewControllers else {
                   return
               }
               for viewController in viewControllers {
                   if viewController == selectedViewController {
                       viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
                   } else {
                       viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 13)], for: .normal)
                   }
               }
           }
       }


}
