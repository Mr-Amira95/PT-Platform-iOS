//
//  AddBodyMeasurmentsVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 15/08/2022.
//

import UIKit
import LanguageManager_iOS

class AddBodyMeasurmentsVC: UIViewController {
    
    @IBOutlet weak var viewNeck: UIView!
    @IBOutlet weak var viewChest: UIView!
    @IBOutlet weak var viewLeftArm: UIView!
    @IBOutlet weak var viewRightArm: UIView!
    @IBOutlet weak var viewWaist: UIView!
    @IBOutlet weak var viewBelly: UIView!
    @IBOutlet weak var viewLowerBelly: UIView!
    @IBOutlet weak var viewUpperBelly: UIView!
    @IBOutlet weak var viewHips: UIView!
    @IBOutlet weak var viewLeftThigh: UIView!
    @IBOutlet weak var viewRightThigh: UIView!
    @IBOutlet weak var viewLeftCalf: UIView!
    @IBOutlet weak var viewRightCalf: UIView!
    
    
    @IBOutlet weak var txtNeck: UITextField!
    @IBOutlet weak var txtChest: UITextField!
    @IBOutlet weak var txtLeftArm: UITextField!
    @IBOutlet weak var txtRightArm: UITextField!
    @IBOutlet weak var txtWaist: UITextField!
    @IBOutlet weak var txtBelly: UITextField!
    @IBOutlet weak var txtLowerBelly: UITextField!
    @IBOutlet weak var txtUpperBelly: UITextField!
    @IBOutlet weak var txtHips: UITextField!
    @IBOutlet weak var txtLeftThigh: UITextField!
    @IBOutlet weak var txtRightThigh: UITextField!
    @IBOutlet weak var txtLeftCalf: UITextField!
    @IBOutlet weak var txtRightCalf: UITextField!
    
        
    
    static func storyboardInstance() -> AddBodyMeasurmentsVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddBodyMeasurmentsVC") as? AddBodyMeasurmentsVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
        if LanguageManager.shared.currentLanguage == .ar{
            txtNeck.textAlignment = .right
            txtChest.textAlignment = .right
            txtLeftArm.textAlignment = .right
            txtRightArm.textAlignment = .right
            txtWaist.textAlignment = .right
            txtBelly.textAlignment = .right
            txtLowerBelly.textAlignment = .right
            txtUpperBelly.textAlignment = .right
            txtHips.textAlignment = .right
            txtLeftThigh.textAlignment = .right
            txtRightThigh.textAlignment = .right
            txtLeftCalf.textAlignment = .right
            txtRightCalf.textAlignment = .right
        }
    }
    
    func setBorder(){
        viewNeck.layer.borderColor = UIColor.white.cgColor
        viewNeck.layer.borderWidth = 1
        viewNeck.layer.cornerRadius = 15
        viewChest.layer.borderColor = UIColor.white.cgColor
        viewChest.layer.borderWidth = 1
        viewChest.layer.cornerRadius = 15
        viewLeftArm.layer.borderColor = UIColor.white.cgColor
        viewLeftArm.layer.borderWidth = 1
        viewLeftArm.layer.cornerRadius = 15
        viewRightArm.layer.borderColor = UIColor.white.cgColor
        viewRightArm.layer.borderWidth = 1
        viewRightArm.layer.cornerRadius = 15
        viewWaist.layer.borderColor = UIColor.white.cgColor
        viewWaist.layer.borderWidth = 1
        viewWaist.layer.cornerRadius = 15
        viewBelly.layer.borderColor = UIColor.white.cgColor
        viewBelly.layer.borderWidth = 1
        viewBelly.layer.cornerRadius = 15
        viewLowerBelly.layer.borderColor = UIColor.white.cgColor
        viewLowerBelly.layer.borderWidth = 1
        viewLowerBelly.layer.cornerRadius = 15
        viewUpperBelly.layer.borderColor = UIColor.white.cgColor
        viewUpperBelly.layer.borderWidth = 1
        viewUpperBelly.layer.cornerRadius = 15
        viewHips.layer.borderColor = UIColor.white.cgColor
        viewHips.layer.borderWidth = 1
        viewHips.layer.cornerRadius = 15
        viewLeftThigh.layer.borderColor = UIColor.white.cgColor
        viewLeftThigh.layer.borderWidth = 1
        viewLeftThigh.layer.cornerRadius = 15
        viewRightThigh.layer.borderColor = UIColor.white.cgColor
        viewRightThigh.layer.borderWidth = 1
        viewRightThigh.layer.cornerRadius = 15
        viewLeftCalf.layer.borderColor = UIColor.white.cgColor
        viewLeftCalf.layer.borderWidth = 1
        viewLeftCalf.layer.cornerRadius = 15
        viewRightCalf.layer.borderColor = UIColor.white.cgColor
        viewRightCalf.layer.borderWidth = 1
        viewRightCalf.layer.cornerRadius = 15
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        let parameter = ["neck" : txtNeck.text!,
                         "chest" : txtChest.text!,
                         "left_arm" : txtLeftArm.text!,
                         "right_arm" : txtRightArm.text!,
                         "waist" : txtWaist.text!,
                         "belly" : txtBelly.text!,
                         "lower_belly" : txtLowerBelly.text!,
                         "upper_belly" : txtUpperBelly.text!,
                         "hips" : txtHips.text!,
                         "left_thigh" : txtLeftThigh.text!,
                         "right_thigh" : txtRightThigh.text!,
                         "lift_calf" : txtLeftCalf.text!,
                         "right_calf" : txtRightCalf.text!]
        if txtNeck.text! == "" || txtChest.text! == "" || txtLeftArm.text! == "" || txtRightArm.text! == "" || txtWaist.text! == "" || txtBelly.text! == "" || txtLowerBelly.text! == "" || txtUpperBelly.text! == "" || txtHips.text! == "" || txtLeftThigh.text! == "" || txtRightThigh.text! == "" || txtLeftCalf.text! == "" || txtRightCalf.text! == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter all values")
        }else{
            Spinner.instance.showSpinner(onView: view)
            ControllerService.instance.BodyMPost(param: parameter) {bool in
                Spinner.instance.removeSpinner()
                if bool{
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBodyMeasurements"), object: nil)
                }
            }
        }
    }
    
}


