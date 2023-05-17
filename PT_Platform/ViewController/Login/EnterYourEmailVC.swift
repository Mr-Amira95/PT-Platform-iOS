//
//  EnterYourEmailVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 20/09/2022.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire


class EnterYourEmailVC: UIViewController {
    
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func verifyEmailSignUp(){
        let parameter = ["email" : txtEmail.text!]
        ControllerService.instance.verifyEmailPost(param: parameter) { message, bool in
            if bool{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "verificationcodeVC") as! verificationcodeVC
                self.present(vc, animated: true, completion: nil)
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    func verifyEmailForgotPassword(){
        let parameter = ["email" : txtEmail.text!]
        ControllerService.instance.verifyEmailResetPasswordPost(param: parameter) { message, bool in
            if bool{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "verificationcodeVC") as! verificationcodeVC
                self.present(vc, animated: true, completion: nil)
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        if txtEmail.text! == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your email")
        }else{
            if Shared.shared.verifyEmailType == "SignUp"{
                verifyEmailSignUp()
            }else if Shared.shared.verifyEmailType == "ForgotPassword"{
                verifyEmailForgotPassword()
            }
            
        }
    }
    
    
}
