//
//  ViewController.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 02/01/2022.
//

import UIKit
import SkyFloatingLabelTextField


class verificationcodeVC: UIViewController {
    
    @IBOutlet weak var txtCode: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func CheckCode(){
        let parameter = ["token" : Shared.shared.token,
                         "code" : txtCode.text!]
        ControllerService.instance.checkCodePost(param: parameter) { message, bool in
            if bool{
                if Shared.shared.verifyEmailType == "SignUp"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Coach") as! Coach
                        self.present(vc, animated: true, completion: nil)
                }else if Shared.shared.verifyEmailType == "ForgotPassword"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func NextBtn(_ sender: Any) {
        if txtCode.text! == ""{
            ToastView.shared.short(self.view, txt_msg: "Please enter the verification code that we have sent to your email")
        }else{
            CheckCode()
        }
    }



}

