//
//  ThankYouVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 20/01/2022.
//

import UIKit

class ThankYouVC: UIViewController {

    private var localTimer = Timer()
    var count = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        localTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            self.count -= 1
            if self.count == 0{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SignInAfterSignUPVC") as! SignInAfterSignUPVC
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
