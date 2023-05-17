//
//  SnacksCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 18/09/2022.
//

import UIKit
import LanguageManager_iOS

class SnacksCell: UITableViewCell {
    
    var Vc : FoodVC?
    var Vc2 : NutritionHistoryVC?
    var datalistSnack : [SnackFoodM] = []
    
    
    @IBOutlet weak var viewAddFood: UIView!
    @IBOutlet weak var btnAddFood: UIButton!
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "SubFoodCell", bundle: nil), forCellReuseIdentifier: "SubFoodCell")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if LanguageManager.shared.currentLanguage == .ar{
            btnAddFood.contentHorizontalAlignment = .right
        }
        self.datalistSnack = Shared.shared.SnackFoodMArray as! [SnackFoodM]
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFood), name: NSNotification.Name(rawValue: "reloadDataFoodIn"), object: nil)
    }
    
    @objc func reloadDataFood() {
        self.datalistSnack = Shared.shared.SnackFoodMArray as! [SnackFoodM]
        setupTableView()
        }
    func setupTableView() {
        tableView.register(UINib(nibName: "SubFoodCell", bundle: nil), forCellReuseIdentifier: "SubFoodCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
}


extension SnacksCell : UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return datalistSnack.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubFoodCell", for: indexPath) as? SubFoodCell
            cell?.lblTitle.text = datalistSnack[indexPath.row].title as? String ?? ""
            cell?.lblName.text = "calorie \(Int(datalistSnack[indexPath.row].calorie as? Double ?? 0.0))"
            cell?.selectionStyle = .none
            return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let food = datalistSnack[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.deleteFood(foodId: food.user_food_id as? Int ?? 0)
        })
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    func deleteFood(foodId:Int) {
        ControllerService.instance.deleteFoodPost(foodId: foodId) { message, bool in
            if bool{
                ToastView.shared.short((self.Vc?.view)!, txt_msg: message)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFood"), object: nil)
            }else{
                
            }
        }
    }

}
