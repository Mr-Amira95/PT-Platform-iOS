//
//  SignInAfterSignUPVC.swift
//  PT_Platform
//
//  Created by mustafakhallad on 19/05/2022.
//

import UIKit
import LanguageManager_iOS
import SkyFloatingLabelTextField

class SignInAfterSignUPVC: UIViewController {
    
    @IBOutlet weak var EmailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var PasswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .ar{
            EmailTxt.textAlignment = .right
            PasswordTxt.textAlignment = .right
            btnSignUp.contentHorizontalAlignment = .right
            btnForgot.contentHorizontalAlignment = .left
        }

    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnForgot(_ sender: Any) {
        Shared.shared.verifyEmailType = "ForgotPassword"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterYourEmailVC") as! EnterYourEmailVC
        self.present(vc, animated: true, completion: nil)
    }
    
    

    @IBAction func LoginBtn(_ sender: Any) {
        if EmailTxt.text!.isEmpty || PasswordTxt.text!.isEmpty == true{
            let alert = UIAlertController(title: "Sign In Faild", message: "Please fill all filds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            Spinner.instance.showSpinner(onView: view)
            let device = ["player_id":Shared.shared.device_player_id ?? 0,
                      "platform":Shared.shared.platform,
                      "timezone":Shared.shared.timezone,
                      "app_version":Shared.shared.appVersion] as [String:Any]
        let param = ["email":EmailTxt.text!,
                     "password":PasswordTxt.text!,
                     "device": device] as [String:Any]
            ControllerService.instance.Login(param: param) { message, bool in
            if bool == true{
                Spinner.instance.removeSpinner()
                if  Shared.shared.getusertype() == "Coach" {
                    Shared.shared.isLogin(auth: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "NavHomePageCoachVC")
                    root.modalPresentationStyle = .fullScreen
                    self.present(root, animated: true, completion: nil)
                }else {
                    let startDate = Date()
                    Shared.shared.saveStartDate(name: startDate)
                    Shared.shared.isLogin(auth: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "ManTabBar") as! ManTabBar
                    root.modalPresentationStyle = .fullScreen
                    self.present(root, animated: true, completion: nil)
                }
            }else{
                Shared.shared.isLogin(auth: false)
                let alert = UIAlertController(title: "Sign In Faild", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                Spinner.instance.removeSpinner()
            }
        }
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        Shared.shared.verifyEmailType = "SignUp"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterYourEmailVC") as! EnterYourEmailVC
        self.present(vc, animated: true, completion: nil)
    }
    

}
