//
//  IntroVC.swift
//  PT_Platform
//
//  Created by mustafakhallad on 22/05/2022.
//

import UIKit
//import OneSignal

class IntroVC: UIViewController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let root = storyboard.instantiateViewController(withIdentifier: "HomePageCoachVC") as! HomePageCoachVC
//        self.present(root, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let root = storyboard.instantiateViewController(withIdentifier: "ManTabBar") as! ManTabBar
        if Shared.shared.getCoachId() == nil {
            let controller = storyboard.instantiateViewController(withIdentifier: "ChooswTrainerVC") as! ChooswTrainerVC
            let nav = UINavigationController(rootViewController: controller)
            root.viewControllers?[1] = nav
            root.viewControllers?[1].tabBarItem.title = "Coach"
            root.viewControllers?[1].tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
            
        }else{
            let controller = storyboard.instantiateViewController(withIdentifier: "ChooswTrainerVC") as! ChooswTrainerVC
            let nav = UINavigationController(rootViewController: controller)
            root.viewControllers?[1] = nav
            root.viewControllers?[1].tabBarItem.title = "Coach"
            root.viewControllers?[1].tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
        }
    }

    
    func check(){
        if Shared.shared.getisLogin() == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyboard.instantiateViewController(withIdentifier: "TellUsVC") as! TellUsVC
            self.present(root, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyboard.instantiateViewController(withIdentifier: "TellUsVC") as! TellUsVC
            self.present(root, animated: true, completion: nil)
        }
    }
 
}
