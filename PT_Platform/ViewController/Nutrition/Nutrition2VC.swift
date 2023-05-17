//
//  Nutrition2VC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 31/01/2022.
//

import UIKit
import LanguageManager_iOS

class Nutrition2VC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCalories: UITextField!
    @IBOutlet weak var lblCarbs: UITextField!
    @IBOutlet weak var lblFat: UITextField!
    @IBOutlet weak var lblProtein: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
        lblCalories.text = Shared.shared.nutritionCalories
        lblCarbs.text = Shared.shared.nutritionCarbs
        lblFat.text = Shared.shared.nutritionFat
        lblProtein.text = Shared.shared.nutritionProtein
        if LanguageManager.shared.currentLanguage == .ar{
            lblCalories.textAlignment = .right
            lblCarbs.textAlignment = .right
            lblFat.textAlignment = .right
            lblProtein.textAlignment = .right
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if lblCalories.text == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter calories number")
        }else{
            setTarget()
        }
    }
    
    func setTarget(){
        let parameter = ["target_calorie" : lblCalories.text!,
                         "target_carb" : lblCarbs.text!,
                         "target_fat" : lblFat.text!,
                         "target_protein" : lblProtein.text!] as [String:Any]
        ControllerService.instance.SetTargetApi(param: parameter) { message, bool in
            if bool{
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataNutrition"), object: nil)
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }

}
