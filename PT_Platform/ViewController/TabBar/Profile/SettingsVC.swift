//
//  SettingsVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/01/2022.
//

import UIKit
import KRProgressHUD
import LanguageManager_iOS


class SettingsVC: UIViewController {
    
    @IBOutlet weak var SwitchNotify: UISwitch!
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        if Shared.shared.getisSendNotification() == true {
            self.SwitchNotify.isOn = true
        }else{
            self.SwitchNotify.isOn = false
        }
    }


    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLanguage(_ sender: Any) {
        guard let nextVc = SelectLanguageVc.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    @IBAction func SwitchNotification(_ sender: Any) {
        KRProgressHUD.show()
        ControllerService.instance.updateNotificationsApi { (message, bool) in
            KRProgressHUD.dismiss()
            if bool{
                self.Alert(Message: message)
            }else{
                self.Alert(Message: message)
            }
        }
    }
    
    @IBAction func btnTerms(_ sender: Any) {
        if let url = URL(string: "https://pt.qtechnetworks.co/app/terms-conditions") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Oops!", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
