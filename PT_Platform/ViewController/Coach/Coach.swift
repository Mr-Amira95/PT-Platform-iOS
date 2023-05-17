//
//  Coach.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 05/01/2022.
//

import UIKit
import SkyFloatingLabelTextField
import OneSignal

class Coach: UIViewController {

    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNickName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSocialMedia: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPotential: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func NextBtn(_ sender: Any) {
        signUp()
    }
    
    func signUp(){
        if txtFirstName.text!.isEmpty || txtNickName.text!.isEmpty || txtSocialMedia.text!.isEmpty ||
            txtPotential.text!.isEmpty || txtPhoneNumber.text!.isEmpty ||
            txtPassword.text!.isEmpty || txtConfirmPassword!.text!.isEmpty == true {
            let alert = UIAlertController(title: "Sign Up Faild", message: "Pleas fill all filds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if txtPassword.text != txtConfirmPassword.text{
            let alert = UIAlertController(title: "Sign Up Faild", message: "Password dosn't match ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            Spinner.instance.showSpinner(onView: view)
            let deviceState = OneSignal.getDeviceState()
            let pleyerId = deviceState?.userId
            let device = ["player_id":pleyerId ?? 0,
                          "platform":Shared.shared.platform,
                          "timezone":Shared.shared.timezone,
                          "app_version":Shared.shared.appVersion] as? NSObject
            let param = ["token" : Shared.shared.token,
                         "full_name":txtFirstName.text!,
                         "nick_name":txtNickName.text!,
                         "link_social_media":txtSocialMedia.text!,
                         "potential_clients":txtPotential.text!,
                         "phone_number":txtPhoneNumber.text!,
                         "password":txtPassword.text!,
                         "password_confirmation":txtConfirmPassword.text!,
                         "device": device!] as [String:Any]
            ControllerService.instance.SignupCoach(param: param) { message, bool in
                Spinner.instance.removeSpinner()
                if bool == true{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "ThankYouVC")
                    self.present(root, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Sign Up Faild", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            }

    }
    
    
    
    
}
