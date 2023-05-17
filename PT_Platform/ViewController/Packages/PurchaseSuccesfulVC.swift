//
//  PurchaseSuccesfulVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit

class PurchaseSuccesfulVC: UIViewController {
    
    private var localTimer = Timer()
    var count = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        localTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            self.count -= 1
            if self.count == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ManTabBar")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
            }
        }

    }
    

    
}
