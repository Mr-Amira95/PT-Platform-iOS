//
//  FollowUsVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit
import LanguageManager_iOS

class FollowUsVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
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
    
    @IBAction func btnFacebook(_ sender: Any) {
        if let url = URL(string: "https://web.facebook.com/profile.php?id=100083373336595") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func btnInstagram(_ sender: Any) {
        if let url = URL(string: "https://instagram.com/pt.platform?igshid=YmMyMTA2M2Y=") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    
    
}
