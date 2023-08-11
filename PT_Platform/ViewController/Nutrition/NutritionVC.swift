//
//  NutritionVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 31/01/2022.
//

import UIKit
import UICircularProgressRing
import LanguageManager_iOS


struct Model7 {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
}

class NutritionVC: UIViewController {
    
    var models7 = [Model7]()

    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblCalories2: UILabel!
    @IBOutlet weak var lblCarbs: UILabel!
    @IBOutlet weak var lblCarbsNew: UILabel!
    @IBOutlet weak var lblFat: UILabel!
    @IBOutlet weak var lblFatNew: UILabel!
    @IBOutlet weak var lblProtein: UILabel!
    @IBOutlet weak var lblProteinNew: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var viewCarbs: UICircularProgressRing!
    @IBOutlet weak var viewFat: UICircularProgressRing!
    @IBOutlet weak var viewProtei: UICircularProgressRing!
    @IBOutlet weak var viewCal1: UICircularProgressRing!
    @IBOutlet weak var viewCal2: UICircularProgressRing!
    @IBOutlet weak var viewCal3: UICircularProgressRing!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HomePageCoachCell", bundle: nil), forCellWithReuseIdentifier: "HomePageCoachCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
        addData7()
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        getTarget()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataNutrition), name: NSNotification.Name(rawValue: "reloadDataNutrition"), object: nil)
    }
    
    @objc func reloadDataNutrition() {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        getTarget()
        }
    
    
    func getTarget(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.nutritionNumbersApi { message, carb, fat, protein, calories, target_carb, target_fat, target_protein, target_calorie, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.lblCalories.text = "\(target_calorie)Cal"
                self.lblCalories2.text = "\(calories)/\(target_calorie) Cal"
                self.progressView.progress = Float(calories)/Float(target_calorie)
                Shared.shared.nutritionCalories = "\(target_calorie)"
                self.viewCal1.startProgress(to: CGFloat(Float(target_calorie)), duration: 1.0)
                self.viewCal2.startProgress(to: CGFloat(Float(target_calorie)), duration: 1.0)
                self.viewCal3.startProgress(to: CGFloat(Float(target_calorie)), duration: 1.0)
                
                self.lblCarbs.text = "\(target_carb)"
                Shared.shared.nutritionCarbs = "\(target_carb)"
                self.lblCarbsNew.text = "\(carb)"
                let carbValue: CGFloat = (carb == 0) ? 1 : CGFloat(Float(carb)/Float(target_carb)*100)
                self.viewCarbs.startProgress(to: carbValue, duration: 1.0)
                
                self.lblFat.text = "\(target_fat)"
                Shared.shared.nutritionFat = "\(target_fat)"
                self.lblFatNew.text = "\(fat)"
                let fatValue: CGFloat = (fat == 0) ? 1 : CGFloat(Float(fat)/Float(target_fat)*100)
                self.viewFat.startProgress(to: fatValue, duration: 1.0)
                
                self.lblProtein.text = "\(target_protein)"
                Shared.shared.nutritionProtein = "\(target_protein)"
                self.lblProteinNew.text = "\(protein)"
                let proteinValue: CGFloat = (protein == 0) ? 1 : CGFloat(Float(protein)/Float(target_protein)*100)
                self.viewProtei.startProgress(to: proteinValue, duration: 1.0)
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
        
    }
    
    func addData7() {
        if LanguageManager.shared.currentLanguage == .en{
            models7.append(Model7(text: "Food", imageName: "IconFood"))
            models7.append(Model7(text: "Supplements", imageName: "IconSupplements"))
            models7.append(Model7(text: "Calorie Calculator", imageName: "IconCalorie"))
            models7.append(Model7(text: "Recipes and Diet Plans", imageName: "IconRecipes"))
        }else{
            models7.append(Model7(text: "الغذاء", imageName: "IconFood"))
            models7.append(Model7(text: "المكملات", imageName: "IconSupplements"))
            models7.append(Model7(text: "حاسبة السعرات الحرارية", imageName: "IconCalorie"))
            models7.append(Model7(text: "الوصفات وخطة الحمية", imageName: "IconRecipes"))
        }

    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Nutrition2VC") as! Nutrition2VC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}


extension NutritionVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 , height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models7.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCoachCell", for: indexPath) as? HomePageCoachCell
        cell?.SetData(data: models7[indexPath.row])
        cell?.lbl.textColor = UIColor(named: "MainColor")
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Shared.shared.btnSubBack = models7[indexPath.row].text
        if models7[indexPath.row].text == "Calorie Calculator" || models7[indexPath.row].text == "حاسبة السعرات الحرارية"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NutritionCalorieCalculatorVC") as! NutritionCalorieCalculatorVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models7[indexPath.row].text == "Food" || models7[indexPath.row].text == "الغذاء"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FoodVC") as! FoodVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NutritionSupplementsVC") as! NutritionSupplementsVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @IBAction func btnInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SourceInfo", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SourceInfoViewController") as! SourceInfoViewController
        controller.type = .caloriesCalculator
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
}
