//
//  NutritionCalorieCalculatorVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 31/01/2022.
//

import UIKit
import LanguageManager_iOS

class NutritionCalorieCalculatorVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubBack: UILabel!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    //    PickerView
    fileprivate var activityPicker = UIPickerView() {
        didSet{
            activityPicker.delegate = self
            activityPicker.dataSource = self
        }
    }
    
    var gender = "male"
    var activity = ["1-3 time","3-5 time","5-7 time","without"]
    var activityAr = ["خامل","قليل النشاط ١-٣ ايام/بالاسبوع","نشط ٤-٦ ايام/بالاسبوع","نشط للغاية"]
    var activityValue = [1.375,1.55,1.75,1.25]



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            txtAge.textAlignment = .right
            txtHeight.textAlignment = .right
            txtWeight.textAlignment = .right
            txtActivity.textAlignment = .right
        }
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnSubBack
        txtActivity.inputView = activityPicker
        activityPicker.delegate = self
        activityPicker.dataSource = self
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCalculate(_ sender: Any) {
        let age = Double(txtAge.text!) ?? 0.0
        let height = Double(txtHeight.text!) ?? 0.0
        let weight = Double(txtWeight.text!) ?? 0.0
        let result = 0.0
        if txtAge.text == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your age")
        }else if gender == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your gender")
        }else if txtHeight.text == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your height")
        }else if txtWeight.text == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your weight")
        }else if txtActivity.text == ""{
            ToastView.shared.short(self.view, txt_msg: "Please, enter your activity")
        }else{
            if gender == "male"{
                let w = 13.7 * weight
                let h = 5 * height
                let a = 6.8 * age
                lblResult.text = "\((w + h - a + 66.5)*Shared.shared.activity) Kcal"
            }else{
                let w = 9.6 * weight
                let h = 1.8 * height
                let a = 4.7 * age
                lblResult.text = "\((w + h - a + 665.5)*Shared.shared.activity) Kcal"
            }
        }
    }
    
    @IBAction func btnMale(_ sender: Any) {
        gender = "male"
        imgMale.image = UIImage(named: "RadioBtn1")
        imgFemale.image = UIImage(named: "RadioBtn2")
    }
    
    @IBAction func btnFemale(_ sender: Any) {
        gender = "female"
        imgMale.image = UIImage(named: "RadioBtn2")
        imgFemale.image = UIImage(named: "RadioBtn1")
    }
    

}


extension NutritionCalorieCalculatorVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if LanguageManager.shared.currentLanguage == .en{
            return activity.count
        }
            return activityAr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if LanguageManager.shared.currentLanguage == .en{
            txtActivity.text = activity[row]
            Shared.shared.activity = activityValue[row]
            return activity[row]
        }
        txtActivity.text = activityAr[row]
        Shared.shared.activity = activityValue[row]
        return activityAr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if LanguageManager.shared.currentLanguage == .en{
            txtActivity.text = activity[row]
            Shared.shared.activity = activityValue[row]
        }else{
            txtActivity.text = activityAr[row]
            Shared.shared.activity = activityValue[row]
        }
    }
    @IBAction func btnInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SourceInfo", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SourceInfoViewController") as! SourceInfoViewController
        controller.type = .caloricBalanceEquation
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
}
