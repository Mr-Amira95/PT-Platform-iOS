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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let root = storyboard.instantiateViewController(withIdentifier: "HomePageCoachVC") as! HomePageCoachVC
        self.present(root, animated: true, completion: nil)
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
