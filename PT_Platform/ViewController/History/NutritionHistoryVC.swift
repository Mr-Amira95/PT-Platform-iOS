//
//  NutritionHistoryVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 31/05/2022.
//

import UIKit
import UICircularProgressRing
import LanguageManager_iOS


class NutritionHistoryVC: UIViewController {
    
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var lblCarbs: UILabel!
    @IBOutlet weak var lblFat: UILabel!
    @IBOutlet weak var lblProtein: UILabel!
    @IBOutlet weak var viewCarbs: UICircularProgressRing!
    @IBOutlet weak var viewFat: UICircularProgressRing!
    @IBOutlet weak var viewProtei: UICircularProgressRing!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    var datalistBreakfast : [BreakfastFoodM] = []
    var datalistDinner : [DinnerFoodM] = []
    var datalistLunch : [LunchFoodM] = []
    var datalistSnack : [SnackFoodM] = []
    var datalistSupplements : [SupplementsFoodM] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        btnCalender.setTitle("\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)-\(dateTimeComponents.day ?? 0)", for: .normal)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        self.navigationController?.navigationBar.isHidden = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataNutritionHistory), name: NSNotification.Name(rawValue: "reloadDataNutritionHistory"), object: nil)
        getNutritionHistory()
    }
    
    @objc func reloadDataNutritionHistory() {
        btnCalender.setTitle("\(Shared.shared.monthto)-\(Shared.shared.datTo)", for: .normal)
        getNutritionHistory()
        }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "BreakfastCell", bundle: nil), forCellReuseIdentifier: "BreakfastCell")
        tableView.register(UINib(nibName: "DinnerCell", bundle: nil), forCellReuseIdentifier: "DinnerCell")
        tableView.register(UINib(nibName: "LunchCell", bundle: nil), forCellReuseIdentifier: "LunchCell")
        tableView.register(UINib(nibName: "SnacksCell", bundle: nil), forCellReuseIdentifier: "SnacksCell")
        tableView.register(UINib(nibName: "SupplementsFoodCell", bundle: nil), forCellReuseIdentifier: "SupplementsFoodCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    func getNutritionHistory(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.nutritionHistoryApi2 { carb, fat, protein, calories, breakfast, dinner, lunch, snack, supplements, target_carb, target_fat, target_protein,  target_calorie, bool in
            Spinner.instance.removeSpinner()
            if bool{
                    self.datalistBreakfast = breakfast
                    Shared.shared.BreakfastFoodMArray = breakfast as NSArray
                    self.datalistDinner = dinner
                    Shared.shared.DinnerFoodMArray = dinner as NSArray
                    self.datalistLunch = lunch
                    Shared.shared.LunchFoodMArray = lunch as NSArray
                    self.datalistSnack = snack
                    Shared.shared.SnackFoodMArray = snack as NSArray
                    self.datalistSupplements = supplements
                    Shared.shared.SupplementsFoodMArray = supplements as NSArray
                    self.tableView.separatorColor = .lightGray
                
                self.lblCarbs.text = "\(carb)"
                self.viewCarbs.startProgress(to: CGFloat(carb), duration: 1.0)
                self.lblFat.text = "\(fat)"
                self.viewFat.startProgress(to: CGFloat(fat), duration: 1.0)
                self.lblProtein.text = "\(protein)"
                self.viewProtei.startProgress(to: CGFloat(protein), duration: 1.0)
                self.progressView.progress = Float(calories)
                if LanguageManager.shared.currentLanguage == .en{
                    self.lblCalories.text = "\(calories) Calories"
                }else{
                    self.lblCalories.text = "سعرات حرارية \(calories)"
                }

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFoodIn"), object: nil)
                self.setupTableView()
            }
        }
    }

    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCalender(_ sender: Any) {
        Shared.shared.calendarEnterScreen = "NutritionHistoryVC"
        guard let nextVc = CalenderPopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
}

extension NutritionHistoryVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let item = datalistBreakfast.count
            return CGFloat((80+60*item))
        }
        if indexPath.section == 1{
            let item = datalistDinner.count
            return CGFloat((80+60*item))
        }
        if indexPath.section == 2{
            let item = datalistLunch.count
            return CGFloat((80+60*item))
        }
        if indexPath.section == 3{
            let item = datalistSnack.count
            return CGFloat((80+60*item))
        }
        let item = datalistSupplements.count
        return CGFloat((80+60*item))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "BreakfastCell", for: indexPath) as? BreakfastCell {
                        cell.selectionStyle = .none
                        cell.tableView.separatorColor = .none
                        cell.Vc2 = self
                        cell.viewAddFood.isHidden = true
                        return cell
                    }
                }else if indexPath.section == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "DinnerCell", for: indexPath) as? DinnerCell {
                        cell.selectionStyle = .none
                        cell.tableView.separatorColor = .none
                        cell.Vc2 = self
                        cell.viewAddFood.isHidden = true
                        return cell
                    }
                }else if indexPath.section == 2{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "LunchCell", for: indexPath) as? LunchCell {
                        cell.selectionStyle = .none
                        cell.tableView.separatorColor = .none
                        cell.Vc2 = self
                        cell.viewAddFood.isHidden = true
                        return cell
                    }
                }else if indexPath.section == 3{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SnacksCell", for: indexPath) as? SnacksCell {
                        cell.selectionStyle = .none
                        cell.tableView.separatorColor = .none
                        cell.Vc2 = self
                        cell.viewAddFood.isHidden = true
                        return cell
                    }
                }else if indexPath.section == 4{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SupplementsFoodCell", for: indexPath) as? SupplementsFoodCell {
                        cell.selectionStyle = .none
                        cell.tableView.separatorColor = .none
                        cell.Vc2 = self
                        cell.viewAddFood.isHidden = true
                        return cell
                    }
                }
        
        return UITableViewCell()
    }
}
