//
//  FoodVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 31/08/2022.
//

import UIKit
import LanguageManager_iOS

struct Model33 {
    let text: String
    let id: Int
    
    init(text: String, id: Int) {
        self.text = text
        self.id = id
    }
}


class FoodVC: UIViewController {
    
    var models33 = [Model33]()
    var selectedIndex = 0
    var datalistBreakfast : [BreakfastFoodM] = []
    var datalistDinner : [DinnerFoodM] = []
    var datalistLunch : [LunchFoodM] = []
    var datalistSnack : [SnackFoodM] = []
    var datalistSupplements : [SupplementsFoodM] = []
    
    
    @IBOutlet weak var btnOpenCalender: UIButton!
    @IBOutlet weak var lblTarget: UILabel!
    @IBOutlet weak var lblFood: UILabel!
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var lblRemaining: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
    didSet{
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AvailableCell", bundle: nil), forCellWithReuseIdentifier: "AvailableCell")
        self.collectionView.reloadData()
    }
}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        Shared.shared.datTo = ""
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        btnOpenCalender.setTitle("\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)-\(dateTimeComponents.day ?? 0)", for: .normal)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        getFoodUser()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFood), name: NSNotification.Name(rawValue: "reloadDataFood"), object: nil)
    }
    
    @objc func reloadDataFood() {
        btnOpenCalender.setTitle("\(Shared.shared.monthto)-\(Shared.shared.datTo)", for: .normal)
        getFoodUser()
        }
    
    func getFoodUser(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.FoodsUserApi { breakfast, dinner, lunch, snack, supplements, message, user_target, food_target, exercise_target, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.lblTarget.text = "\(user_target)"
                self.lblFood.text = "\(food_target)"
                self.lblExercise.text = "\(exercise_target)"
                let remaining = user_target - food_target
                self.lblRemaining.text = "\(remaining)"
                
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFoodIn"), object: nil)
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataNutrition"), object: nil)
    }
    
    @IBAction func btnOpenCalender(_ sender: Any) {
        Shared.shared.calendarEnterScreen = "FoodVC"
        guard let nextVc = CalenderPopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    
}

extension FoodVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models33.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableCell", for: indexPath) as? AvailableCell
        cell?.lblTime.text = models33[indexPath.row].text
        if selectedIndex == indexPath.item{
            cell?.lblTime.backgroundColor = UIColor(red:141/255, green:198/255, blue:62/255, alpha: 1)
            cell?.lblTime.layer.cornerRadius = 20
            cell?.lblTime.layer.masksToBounds = true
        }else{
            cell?.lblTime.backgroundColor = .none
        }
            return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        self.collectionView.reloadData()
    }
}

extension FoodVC : UITableViewDataSource, UITableViewDelegate {
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
                        cell.Vc = self
                        cell.btnAddFood.tag = indexPath.row
                        cell.btnAddFood.addTarget(self, action: #selector(btnAddBreakfast(_:)), for: .touchUpInside)
                        return cell
                    }
                }else if indexPath.section == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "DinnerCell", for: indexPath) as? DinnerCell {
                        cell.selectionStyle = .none
                        cell.Vc = self
                        cell.btnAddFood.tag = indexPath.row
                        cell.btnAddFood.addTarget(self, action: #selector(btnAddDinner(_:)), for: .touchUpInside)
                        return cell
                    }
                }else if indexPath.section == 2{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "LunchCell", for: indexPath) as? LunchCell {
                        cell.selectionStyle = .none
                        cell.Vc = self
                        cell.btnAddFood.tag = indexPath.row
                        cell.btnAddFood.addTarget(self, action: #selector(btnAddLunch(_:)), for: .touchUpInside)
                        return cell
                    }
                }else if indexPath.section == 3{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SnacksCell", for: indexPath) as? SnacksCell {
                        cell.selectionStyle = .none
                        cell.Vc = self
                        cell.btnAddFood.tag = indexPath.row
                        cell.btnAddFood.addTarget(self, action: #selector(btnAddSnacks(_:)), for: .touchUpInside)
                        return cell
                    }
                }else if indexPath.section == 4{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SupplementsFoodCell", for: indexPath) as? SupplementsFoodCell {
                        cell.selectionStyle = .none
                        cell.btnAddFood.tag = indexPath.row
                        cell.btnAddFood.addTarget(self, action: #selector(btnAddSupplements(_:)), for: .touchUpInside)
                        cell.Vc = self
                        return cell
                    }
                }
        return UITableViewCell()
    }
    
    @objc func btnAddBreakfast(_ sender:UIButton){
        Shared.shared.typeFood = "breakfast"
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    @objc func btnAddDinner(_ sender:UIButton){
        Shared.shared.typeFood = "dinner"
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    @objc func btnAddLunch(_ sender:UIButton){
        Shared.shared.typeFood = "lunch"
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    @objc func btnAddSnacks(_ sender:UIButton){
        Shared.shared.typeFood = "snack"
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    @objc func btnAddSupplements(_ sender:UIButton){
        Shared.shared.typeFood = "supplements"
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    
    
}
