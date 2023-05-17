//
//  NoAuthorizedVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 14/09/2022.
//

import UIKit
import LanguageManager_iOS

class NoAuthorizedVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        lblTitle.text = Shared.shared.btnBack
    }
    
    
    @IBAction func btnSubscribe(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
