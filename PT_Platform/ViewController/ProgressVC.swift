//
//  ProgressVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit
import LanguageManager_iOS
import UICircularProgressRing


class ProgressVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFat: UILabel!
    @IBOutlet weak var lblMuscle: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblWater: UILabel!
    @IBOutlet weak var imgFat: UIImageView!
    @IBOutlet weak var imgMuscle: UIImageView!
    @IBOutlet weak var imgWeight: UIImageView!
    @IBOutlet weak var imgWater: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var viewFat: UICircularProgressRing!
    @IBOutlet weak var viewMuscle: UICircularProgressRing!
    @IBOutlet weak var viewWeight: UICircularProgressRing!
    @IBOutlet weak var viewWater: UICircularProgressRing!
    
    
    
    var datalist = [HealthsM]()
    var datalistBody = [BodyMeasurementsM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBodyMeasurements), name: NSNotification.Name(rawValue: "reloadBodyMeasurements"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHealth), name: NSNotification.Name(rawValue: "reloadHealth"), object: nil)
        getBody()
        getHealth()

        lblTitle.text = Shared.shared.btnBack
    }
    
    @objc func reloadBodyMeasurements() {
        self.getBody()
        }
    
    @objc func reloadHealth() {
        self.getHealth()
        }

    
    func setupTableView() {
        tableView.register(UINib(nibName: "WeightProCell", bundle: nil), forCellReuseIdentifier: "WeightProCell")
        tableView.register(UINib(nibName: "BodyCell", bundle: nil), forCellReuseIdentifier: "BodyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getBody(){
        ControllerService.instance.BodyMPage { body, message, bool in
            if bool{
                self.datalistBody = body
                Shared.shared.bodyMArray = body as NSArray
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBodyMeasurementsIn"), object: nil)
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    func getHealth(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.healthsApi { health, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = health
                for i in health{
                    if i.key == "fat"{
                        self.lblFat.text = "\(String(format: "%.1f", ceil((i.value)*100)/100))%"
                        let fatValue = i.value == 0.0 ? 1.0 : i.value
                        self.viewFat.startProgress(to: fatValue,duration: 1.0)
                        if i.type == "decrease"{
                            self.imgFat.image = UIImage(named: "FatDown")
                        }
                    }else if i.key == "muscle"{
                        self.lblMuscle.text = "\(String(format: "%.1f", ceil((i.value)*100)/100))%"
                        let muscleValue = i.value == 0.0 ? 1.0 : i.value
                        self.viewMuscle.startProgress(to: muscleValue,duration: 1.0)
                        if i.type == "decrease"{
                            self.imgMuscle.image = UIImage(named: "MuscleDown")
                        }
                    }else if i.key == "weight"{
                        self.lblWeight.text = "\(String(format: "%.1f", ceil((i.value)*100)/100))%"
                        let weightValue = i.value == 0.0 ? 1.0 : i.value
                        self.viewWeight.startProgress(to: weightValue, duration: 1.0)
                        if i.type == "decrease"{
                            self.imgWeight.image = UIImage(named: "WeightDown")
                        }
                    }else if i.key == "water"{
                        self.lblWater.text = "\(String(format: "%.1f", ceil((i.value)*100)/100))%"
                        let waterValue = i.value == 0.0 ? 1.0 : i.value
                        self.viewWater.startProgress(to: waterValue, duration: 1.0)
                        if i.type == "decrease"{
                            self.imgWater.image = UIImage(named: "WaterDown")
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHealthIn"), object: nil)
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: "Somthing wrong")
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension ProgressVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 350
        }else if indexPath.section == 1{
            return 700
        }
        return 100
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "WeightProCell", for: indexPath) as? WeightProCell {
                    cell.selectionStyle = .none
                    cell.Vc = self
                    return cell
                }
            }else if indexPath.section == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath) as? BodyCell {
                    cell.selectionStyle = .none
                    cell.Vc = self
                    return cell
                }
            }
        return UITableViewCell()
    }
}
