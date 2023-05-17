//
//  EditNamePopupVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 16/11/2022.
//

import UIKit
import KRProgressHUD

class EditNamePopupVC: UIViewController {
    
    var  Vc : ProfileVC?
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    static func storyboardInstance() -> EditNamePopupVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EditNamePopupVC") as? EditNamePopupVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped))
            self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        txtFirstName.text = Shared.shared.getfirst_name() ?? ""
        txtLastName.text = Shared.shared.getlast_name() ?? ""
    }
    
    @objc func touchTapped() {
        self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func btnSave(_ sender: Any) {
        let parameter = ["first_name" : txtFirstName.text!,
                         "last_name" : txtLastName.text!] as [String : Any]
        KRProgressHUD.show()
        ControllerService.instance.editNameProfile(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataName"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    

}
