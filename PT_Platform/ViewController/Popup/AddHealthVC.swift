//
//  AddHealthVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 16/08/2022.
//

import UIKit
import KRProgressHUD
import LanguageManager_iOS

class AddHealthVC: UIViewController {
    
    
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewMuscle: UIView!
    @IBOutlet weak var viewFat: UIView!
    @IBOutlet weak var viewWater: UIView!
    @IBOutlet weak var viewActive: UIView!
    @IBOutlet weak var viewSteps: UIView!
    
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtMuscle: UITextField!
    @IBOutlet weak var txtFat: UITextField!
    @IBOutlet weak var txtWater: UITextField!
    @IBOutlet weak var txtActive: UITextField!
    @IBOutlet weak var txtSteps: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    
    
    var onlyHealth = 0.0
    
    let endDate = Date()
    
    static func storyboardInstance() -> AddHealthVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddHealthVC") as? AddHealthVC
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            btnBack.setImage(UIImage(named: "btnBackWhite"), for: .normal)
        }else{
            btnBack.setImage(UIImage(named: "btnBackWhiteAr"), for: .normal)
            txtWeight.textAlignment = .right
            txtMuscle.textAlignment = .right
            txtFat.textAlignment = .right
            txtWater.textAlignment = .right
            txtActive.textAlignment = .right
            txtSteps.textAlignment = .right
        }
        setBorder()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
        if txtSteps.text?.count == 0{
            txtSteps.isEnabled = true
        } 
    }

    
    func setBorder(){
        viewWeight.layer.borderColor = UIColor.white.cgColor
        viewWeight.layer.borderWidth = 1
        viewWeight.layer.cornerRadius = 15
        viewMuscle.layer.borderColor = UIColor.white.cgColor
        viewMuscle.layer.borderWidth = 1
        viewMuscle.layer.cornerRadius = 15
        viewFat.layer.borderColor = UIColor.white.cgColor
        viewFat.layer.borderWidth = 1
        viewFat.layer.cornerRadius = 15
        viewWater.layer.borderColor = UIColor.white.cgColor
        viewWater.layer.borderWidth = 1
        viewWater.layer.cornerRadius = 15
        viewActive.layer.borderColor = UIColor.white.cgColor
        viewActive.layer.borderWidth = 1
        viewActive.layer.cornerRadius = 15
        viewSteps.layer.borderColor = UIColor.white.cgColor
        viewSteps.layer.borderWidth = 1
        viewSteps.layer.cornerRadius = 15
    }
        
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        let parameter = ["weight" : txtWeight.text!,
                         "muscle" : txtMuscle.text!,
                         "fat" : txtFat.text!,
                         "water" : txtWater.text!,
                         "active_calories" : txtActive.text!,
                         "steps" : txtSteps.text!]
        if txtWeight.text! == "" || txtMuscle.text! == "" || txtFat.text! == "" || txtWater.text! == "" || txtActive.text! == "" || txtSteps.text! == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter all values")
        }else{
            ControllerService.instance.healthsPost(param: parameter) { bool in
                if bool{
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHealth"), object: nil)
                }
            }
        }
    }
}
