//
//  ContactUsVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit
import LanguageManager_iOS

class ContactUsVC: UIViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }

    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTSupport(_ sender: Any) {
        Shared.shared.btnBack = "Technical Support"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
   
    @IBAction func btnFeedback(_ sender: Any) {
        Shared.shared.btnBack = "Feedback"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    

}
