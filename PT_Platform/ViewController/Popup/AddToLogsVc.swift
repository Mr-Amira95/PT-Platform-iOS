//
//  AddToLogsVc.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/05/2022.
//

import UIKit

class AddToLogsVc: UIViewController {
    
    
    @IBOutlet weak var txtSetNumber: UITextField!
    @IBOutlet weak var txtWeightUnit: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtRepititions: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    
    
    static func storyboardInstance() -> AddToLogsVc? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddToLogsVc") as? AddToLogsVc
    }
    
    //MARK:- Variables
    let WeightUnitArray = ["Pounds (lb)","Kilograms (kg)","Stones (st)"]
    let WeightUnitArrayIn = ["pound","kilogram","stone"]
    var WeightUnit = ""
    let SetNumberArray = ["1","2","3","4","5","6","7","8","9","10"]
    var SetNumber = ""
    var numberOfSet = 1
    
    
    //    PickerView
    fileprivate var WeightUnitPicker = UIPickerView() {
        didSet{
            WeightUnitPicker.delegate = self
            WeightUnitPicker.dataSource = self
        }
    }
    
    fileprivate var SetNumberPicker = UIPickerView() {
        didSet{
            SetNumberPicker.delegate = self
            SetNumberPicker.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        txtWeight.textColor = .black
        txtRepititions.textColor = .black
        txtNote.textColor = .black
        txtWeightUnit.inputView = WeightUnitPicker
        WeightUnitPicker.delegate = self
        WeightUnitPicker.dataSource = self
        txtSetNumber.inputView = SetNumberPicker
        SetNumberPicker.delegate = self
        SetNumberPicker.dataSource = self
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setLogs(){
        let parameter = ["video_id" : Shared.shared.video_id,
                         "number" : "1",
                         "weight" : txtWeight.text!,
                         "weight_unit" : WeightUnit,
                         "repetition" : txtRepititions.text!,
                         "note" : txtNote.text!] as [String : Any]
        if self.numberOfSet <= Int(self.SetNumber) ?? 0{
            ControllerService.instance.SetLogsVideoPage(param: parameter) { message, bool in
                if bool{
                    self.txtSetNumber.isEnabled = false
                    self.txtWeightUnit.isEnabled = false
                    self.txtWeight.text = ""
                    self.txtRepititions.text = ""
                    self.txtNote.text = ""
                    if self.numberOfSet == Int(self.SetNumber) ?? 0{
                        self.Alert(Title: "Successfully", Message: "Add all sets is finish")
                    }else{
                        ToastView.shared.short(self.view, txt_msg: "Please, add the next set details.")
                    }
                    self.numberOfSet += 1
                }else{
                    self.Alert(Title: "Wronge", Message: message)
                }
            }
        }else{
            self.Alert(Title: "Successfully", Message: "Add all sets is finish")
        }

    }
    
    
    @IBAction func BtnSave(_ sender: Any) {
        if SetNumber == "" {
            ToastView.shared.short(self.view, txt_msg: "Please, select number")
        }else if WeightUnit == "" {
            ToastView.shared.short(self.view, txt_msg: "Please, select weight unit")
        }else if txtWeight.text! == "" {
            ToastView.shared.short(self.view, txt_msg: "Please, enter weight")
        }else if txtRepititions.text! == "" {
            ToastView.shared.short(self.view, txt_msg: "Please, enter repititions")
        }
        else{
            setLogs()
        }
    }
    
    func Alert (Title: String,Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    

}


extension AddToLogsVc: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == WeightUnitPicker{
            return WeightUnitArray.count
        }
            return SetNumberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == WeightUnitPicker{
            txtWeightUnit.text = WeightUnitArray[row]
            WeightUnit = WeightUnitArrayIn[row]
            return WeightUnitArray[row]
        }
        txtSetNumber.text = SetNumberArray[row]
        SetNumber = SetNumberArray[row]
        return SetNumberArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == WeightUnitPicker{
            txtWeightUnit.text = WeightUnitArray[row]
            WeightUnit = WeightUnitArrayIn[row]
        }else{
            txtSetNumber.text = SetNumberArray[row]
            SetNumber = SetNumberArray[row]
        }
    }
    
}
