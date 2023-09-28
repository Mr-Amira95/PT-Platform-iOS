//
//  SignInVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 04/01/2022.
//

import UIKit
import SkyFloatingLabelTextField

class SignInVC: UIViewController {
    @IBOutlet weak var EmailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var PasswordTxt: SkyFloatingLabelTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                    self.present(root, animated: true, completion: nil)
                }else{
                    let startDate = Date()
                    Shared.shared.saveStartDate(name: startDate)
                    Shared.shared.isLogin(auth: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "ManTabBar") as! ManTabBar
                    if Shared.shared.getCoachId() == nil {
                        let controller = storyboard.instantiateViewController(withIdentifier: "ChooswTrainerVC") as! ChooswTrainerVC
                        let nav = UINavigationController(rootViewController: controller)
                        root.viewControllers?[1] = nav
                        root.viewControllers?[1].tabBarItem.title = "Coach"
                        root.viewControllers?[1].tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
                    }
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
    
    @IBAction func SignUpBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TraineeVC") as! TraineeVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
}

