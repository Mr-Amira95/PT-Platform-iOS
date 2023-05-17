//
//  ForgotPasswordVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 11/12/2022.
//

import UIKit
import SkyFloatingLabelTextField


class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if txtPassword.text!.isEmpty || txtConfirmPassword!.text!.isEmpty == true {
            let alert = UIAlertController(title: "Forgot Password", message: "Please fill all filds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if txtPassword.text != txtConfirmPassword.text{
            let alert = UIAlertController(title: "Forgot Password", message: "Password dosn't match ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            resetPassword()
        }
    }
    
    func resetPassword(){
        let parameter = ["token" : Shared.shared.token,
                         "password" : txtPassword.text!,
                         "password_confirmation" : txtConfirmPassword.text!]
        ControllerService.instance.resetPasswordPost(param: parameter) { message, bool in
            if bool{
                if  Shared.shared.getusertype() == "Coach" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInAfterSignUPVC") as! SignInAfterSignUPVC
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    

}
