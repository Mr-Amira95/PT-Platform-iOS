//
//  AddFoodVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 01/06/2022.
//

import UIKit
import GMStepper
import LanguageManager_iOS

class AddFoodVC: UIViewController {
    
    
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lblProteinValue: UILabel!
    @IBOutlet weak var lblProteinPercentage: UILabel!
    @IBOutlet weak var lblFatValue: UILabel!
    @IBOutlet weak var lblFatPercentage: UILabel!
    @IBOutlet weak var lblCarbsValue: UILabel!
    @IBOutlet weak var lblCarbsPercentage: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var stepperQ: GMStepper!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    var dataList = [FoodsM]()
    var foodId = 0
    
    var protein : Float = 0.0
    var fat : Float = 0.0
    var carb : Float = 0.0
    var calorie : Float = 0.0
    var foodName = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        getFoods()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFoodInAddFoodVC), name: NSNotification.Name(rawValue: "reloadDataFoodInAddFoodVC"), object: nil)
    }
    
    @objc func reloadDataFoodInAddFoodVC() {
        self.dataList.removeAll()
        
        self.dataList = Shared.shared.FoodListMArray as! [FoodsM]
        let indexPath = Shared.shared.FoodListId
        
        self.foodId = dataList[indexPath].id
        self.txt.text = dataList[indexPath].name
        self.lblProteinValue.text = String(format: "%.2f", ceil((dataList[indexPath].protein)*100)/100)
        self.lblFatValue.text = String(format: "%.2f", ceil((dataList[indexPath].fat)*100)/100)
        self.lblCarbsValue.text = String(format: "%.2f", ceil((dataList[indexPath].carb)*100)/100)
        self.lblCalories.text = "\(Int(dataList[indexPath].calorie))"
        
        self.protein = Float(dataList[indexPath].protein)
        self.fat = Float(dataList[indexPath].fat)
        self.carb = Float(dataList[indexPath].carb)
        self.calorie = Float(dataList[indexPath].calorie)
        self.stepperQ.value = 1
        }
    
    func getFoods(){
        ControllerService.instance.FoodsApi { foods, bool in
            if bool{
                if foods.count != 0{
                    self.dataList = foods
                    Shared.shared.FoodListMArray = foods as NSArray
                    self.foodId = foods[0].id
                    self.txt.text = foods[0].name
                    self.lblProteinValue.text = String(format: "%.2f", ceil((foods[0].protein)*100)/100)
                    self.lblFatValue.text = String(format: "%.2f", ceil((foods[0].fat)*100)/100)
                    self.lblCarbsValue.text = String(format: "%.2f", ceil((foods[0].carb)*100)/100)
                    self.lblCalories.text = "\(Int(foods[0].calorie))"
                    
                    self.protein = Float(foods[0].protein)
                    self.fat = Float(foods[0].fat)
                    self.carb = Float(foods[0].carb)
                    self.calorie = Float(foods[0].calorie)
                }else{
                    ToastView.shared.short(self.view, txt_msg: "List food is empty")
                }
            }
        }
    }
    @IBAction func stepperQ(_ sender: Any) {
        let stepper = Float(stepperQ.value)
        self.lblProteinValue.text = String(format: "%.2f", ceil((protein * stepper)*100)/100)
        self.lblFatValue.text = String(format: "%.2f", ceil((fat * stepper)*100)/100)
        self.lblCarbsValue.text = String(format: "%.2f", ceil((carb * stepper)*100)/100)
        self.lblCalories.text = "\(Int(calorie * stepper))"
    }
    
    
    
    
    @IBAction func btnDone(_ sender: Any) {
        let parameter = ["food_id" : foodId,
                         "type":Shared.shared.typeFood,
                         "number":stepperQ.value] as [String : Any]
        ControllerService.instance.foodPost(param: parameter) { message, bool in
            if bool{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFood"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnOpenListFood(_ sender: Any) {
        guard let nextVc = ListFoodPopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}