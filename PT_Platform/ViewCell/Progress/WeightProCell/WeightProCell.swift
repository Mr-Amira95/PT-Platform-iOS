//
//  WeightProCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit
import LanguageManager_iOS

struct itemData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class WeightProCell: UITableViewCell {
    
    var tableViewData = [itemData]()
    var Vc : ProgressVC?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Shared.shared.getusertype() == "Coach"{
            btnUpdate.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHealth), name: NSNotification.Name(rawValue: "reloadHealthIn"), object: nil)
        setData()
    }
    
    @objc func reloadHealth() {
        setData()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeightProDetailsCell", bundle: nil), forCellReuseIdentifier: "WeightProDetailsCell")
    }

    func setData(){
        if LanguageManager.shared.currentLanguage == .en{
            tableViewData = [itemData(opened: false, title: "Weight", sectionData: ["\(Shared.shared.healthsWeight)kg"]),
                             itemData(opened: false, title: "Muscle", sectionData: ["\(Shared.shared.healthsMuscle)"]),
                             itemData(opened: false, title: "Fat", sectionData: ["\(Shared.shared.healthsFat)%"]),
                             itemData(opened: false, title: "Water", sectionData: ["\(Shared.shared.healthsWater)g"]),
                             itemData(opened: false, title: "Active Calories", sectionData: ["\(Shared.shared.healthsActiveCalories)"]),
                             itemData(opened: false, title: "Steps", sectionData: ["\(Shared.shared.healthsSteps)"])]
        }else{
            tableViewData = [itemData(opened: false, title: "الوزن", sectionData: ["\(Shared.shared.healthsWeight)kg"]),
                             itemData(opened: false, title: "العضلات", sectionData: ["\(Shared.shared.healthsMuscle)"]),
                             itemData(opened: false, title: "الدهون", sectionData: ["\(Shared.shared.healthsFat)%"]),
                             itemData(opened: false, title: "ماء", sectionData: ["\(Shared.shared.healthsWater)g"]),
                             itemData(opened: false, title: "السعرات المحروقه", sectionData: ["\(Shared.shared.healthsActiveCalories)"]),
                             itemData(opened: false, title: "الخطوات", sectionData: ["\(Shared.shared.healthsSteps)"])]
        }
        setupTableView()
    }
    
    
    @IBAction func btnUpdate(_ sender: Any) {
        guard let nextVc = AddHealthVC.storyboardInstance() else {return}
        self.Vc?.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    func Alert (Message: String){
        let alert = UIAlertController(title: "Ooops!", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.Vc?.present(alert, animated: true, completion: nil)
    }

}


extension WeightProCell : UITableViewDataSource, UITableViewDelegate {
     func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 45
        }else{
            return 60
        }
        return 60
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataIndex = indexPath.row - 1
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeightProDetailsCell", for: indexPath) as? WeightProDetailsCell
            cell?.lblName.text = tableViewData[indexPath.section].title
            cell?.lblName.textColor = UIColor(named: "MainColor")
            if LanguageManager.shared.currentLanguage == .en{
                cell?.lblName.textAlignment = .left
            }else{
                cell?.lblName.textAlignment = .right
            }
            cell?.lblName.font = UIFont(name: "Noto Kufi Arabic", size: 17)
            cell?.view.backgroundColor = UIColor.darkGray
            cell?.icon.isHidden = false
            if tableViewData[indexPath.section].opened == true{
                cell?.icon.image = UIImage(named: "UpIcon")
            }else{
                cell?.icon.image = UIImage(named: "DownIcon")
            }
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeightProDetailsCell", for: indexPath) as? WeightProDetailsCell
            cell?.lblName.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell?.lblName.textColor = UIColor.white
            cell?.lblName.textAlignment = .center
            cell?.lblName.font = UIFont(name: "Noto Kufi Arabic", size: 20)
            cell?.view.backgroundColor = nil
            cell?.icon.isHidden = true
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
            let section = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(section, with: .none)
            
        }
    }
    
}
