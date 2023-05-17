//
//  TraineeVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 05/01/2022.
//

import UIKit
import SkyFloatingLabelTextField
class TraineeVC: UIViewController {
    @IBOutlet weak var first_nameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var last_nameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var password_confirmationTxt: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func NextBtn(_ sender: Any) {
        if first_nameTxt.text!.isEmpty || last_nameTxt.text!.isEmpty || emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty || passwordTxt!.text!.isEmpty == true {
            let alert = UIAlertController(title: "Sign Up Faild", message: "Please fill all filds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if passwordTxt.text != password_confirmationTxt.text{
            let alert = UIAlertController(title: "Sign Up Faild", message: "Password dosn't match ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            Spinner.instance.showSpinner(onView: view)
            let device = ["player_id":Shared.shared.device_player_id,
                          "platform":Shared.shared.platform,
                          "timezone":Shared.shared.timezone,
                          "app_version":Shared.shared.appVersion] as? NSObject
            
            let param = ["email":emailTxt.text!,
                         "first_name":first_nameTxt.text!,
                         "last_name":last_nameTxt.text!,
                         "password":passwordTxt.text!,
                         "password_confirmation":password_confirmationTxt.text!,
                         "device": device!] as [String:Any]
            ControllerService.instance.Signup(param: param) { message, bool in
                Spinner.instance.removeSpinner()
                if bool == true{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "ManTabBar") as! ManTabBar
                    self.present(root, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            }
            
        }
        
           
       
    
   

}

