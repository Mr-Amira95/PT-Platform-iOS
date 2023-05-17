//
//  BodyCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit
import LanguageManager_iOS

class BodyCell: UITableViewCell {
    
    var array0 = ["DATE :","NECK :","CHEST :","LEFT ARM :","RIGHT ARM :","WAIST :","BELLY :","LOWER BELLY :","UPPER BELLY :","HIPS :","LEFT THIGH :","RIGHT THIGH :","LEFT CALF :","RIGHT CALF :"]
    var array1 = ["DATE :","NECK :","CHEST :","LEFT ARM :","RIGHT ARM :","WAIST :","BELLY :","LOWER BELLY :","UPPER BELLY :","HIPS :","LEFT THIGH :","RIGHT THIGH :","LEFT CALF :","RIGHT CALF :"]
    var datalist = [BodyMeasurementsM]()
    var Vc : ProgressVC?
    
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Shared.shared.getusertype() == "Coach"{
            btnUpdate.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBodyMeasurements), name: NSNotification.Name(rawValue: "reloadBodyMeasurementsIn"), object: nil)
        setData()
    }
    
    @objc func reloadBodyMeasurements() {
        setData()
    }
    
    func setData(){
        if Shared.shared.permissionBody == "yes"{
            datalist = Shared.shared.bodyMArray as! [BodyMeasurementsM]
            if datalist.count == 2{
                if LanguageManager.shared.currentLanguage == .en{
                    array1 = ["DATE : \(datalist[0].date)",
                             "NECK : \(datalist[0].neck)",
                             "CHEST : \(datalist[0].chest)",
                             "LEFT ARM : \(datalist[0].left_arm)",
                             "RIGHT ARM : \(datalist[0].right_arm)",
                             "WAIST : \(datalist[0].waist)",
                             "BELLY : \(datalist[0].belly)",
                             "LOWER BELLY : \(datalist[0].lower_belly)",
                             "UPPER BELLY : \(datalist[0].upper_belly)",
                             "HIPS : \(datalist[0].hips)",
                             "LEFT THIGH : \(datalist[0].left_thigh)",
                             "RIGHT THIGH : \(datalist[0].right_thigh)",
                             "LEFT CALF : \(datalist[0].lift_calf)",
                             "RIGHT CALF : \(datalist[0].right_calf)"]
                    setupTableView1()
                    array0 = ["DATE : \(datalist[1].date)",
                             "NECK : \(datalist[1].neck)",
                             "CHEST : \(datalist[1].chest)",
                             "LEFT ARM : \(datalist[1].left_arm)",
                             "RIGHT ARM : \(datalist[1].right_arm)",
                             "WAIST : \(datalist[1].waist)",
                             "BELLY : \(datalist[1].belly)",
                             "LOWER BELLY : \(datalist[1].lower_belly)",
                             "UPPER BELLY : \(datalist[1].upper_belly)",
                             "HIPS : \(datalist[1].hips)",
                             "LEFT THIGH : \(datalist[1].left_thigh)",
                             "RIGHT THIGH : \(datalist[1].right_thigh)",
                             "LEFT CALF : \(datalist[1].lift_calf)",
                             "RIGHT CALF : \(datalist[1].right_calf)"]
                    setupTableView2()
                }else{
                    array1 = ["التاريخ \(datalist[0].date)",
                             "الرقبة \(datalist[0].neck)",
                             "الصدر \(datalist[0].chest)",
                             "اليد اليسرى \(datalist[0].left_arm)",
                             "اليد اليمنى \(datalist[0].right_arm)",
                             "الخصر \(datalist[0].waist)",
                             "البطن \(datalist[0].belly)",
                             "البطن العلوي \(datalist[0].lower_belly)",
                             "البطن السفلي \(datalist[0].upper_belly)",
                             "الارداف \(datalist[0].hips)",
                             "الفخذ الايسر \(datalist[0].left_thigh)",
                             "الفخذ الايمن \(datalist[0].right_thigh)",
                             "السمانة اليسرى \(datalist[0].lift_calf)",
                             "السمانة اليمنى \(datalist[0].right_calf)"]
                    setupTableView1()
                    array0 = ["التاريخ \(datalist[1].date)",
                              "الرقبة \(datalist[1].neck)",
                              "الصدر \(datalist[1].chest)",
                              "اليد اليسرى \(datalist[1].left_arm)",
                              "اليد اليمنى \(datalist[1].right_arm)",
                              "الخصر \(datalist[1].waist)",
                              "البطن \(datalist[1].belly)",
                              "البطن العلوي \(datalist[1].lower_belly)",
                              "البطن السفلي \(datalist[1].upper_belly)",
                              "الارداف \(datalist[1].hips)",
                              "الفخذ الايسر \(datalist[1].left_thigh)",
                              "الفخذ الايمن \(datalist[1].right_thigh)",
                              "السمانة اليسرى \(datalist[1].lift_calf)",
                              "السمانة اليمنى \(datalist[1].right_calf)"]
                    setupTableView2()
                }

            }else if datalist.count == 1{
                if LanguageManager.shared.currentLanguage == .en{
                    array0 = ["DATE : \(datalist[0].date)",
                             "NECK : \(datalist[0].neck)",
                             "CHEST : \(datalist[0].chest)",
                             "LEFT ARM : \(datalist[0].left_arm)",
                             "RIGHT ARM : \(datalist[0].right_arm)",
                             "WAIST : \(datalist[0].waist)",
                             "BELLY : \(datalist[0].belly)",
                             "LOWER BELLY : \(datalist[0].lower_belly)",
                             "UPPER BELLY : \(datalist[0].upper_belly)",
                             "HIPS : \(datalist[0].hips)",
                             "LEFT THIGH : \(datalist[0].left_thigh)",
                             "RIGHT THIGH : \(datalist[0].right_thigh)",
                             "LEFT CALF : \(datalist[0].lift_calf)",
                             "RIGHT CALF : \(datalist[0].right_calf)"]
                    setupTableView1()
                    array1 = ["DATE : ",
                             "NECK : ",
                             "CHEST : ",
                             "LEFT ARM : ",
                             "RIGHT ARM : ",
                             "WAIST : ",
                             "BELLY : ",
                             "LOWER BELLY : ",
                             "UPPER BELLY : ",
                             "HIPS : ",
                             "LEFT THIGH : ",
                             "RIGHT THIGH : ",
                             "LEFT CALF : ",
                             "RIGHT CALF : "]
                    setupTableView2()
                }else{
                    array0 = ["التاريخ \(datalist[0].date)",
                              "الرقبة \(datalist[0].neck)",
                              "الصدر \(datalist[0].chest)",
                              "اليد اليسرى \(datalist[0].left_arm)",
                              "اليد اليمنى \(datalist[0].right_arm)",
                              "الخصر \(datalist[0].waist)",
                              "البطن \(datalist[0].belly)",
                              "البطن العلوي \(datalist[0].lower_belly)",
                              "البطن السفلي \(datalist[0].upper_belly)",
                              "الارداف \(datalist[0].hips)",
                              "الفخذ الايسر \(datalist[0].left_thigh)",
                              "الفخذ الايمن \(datalist[0].right_thigh)",
                              "السمانة اليسرى \(datalist[0].lift_calf)",
                              "السمانة اليمنى \(datalist[0].right_calf)"]

                    setupTableView1()
                    array1 = ["التاريخ",
                              "الرقبة",
                              "الصدر",
                              "اليد اليسرى",
                              "اليد اليمنى",
                              "الخصر",
                              "البطن",
                              "البطن العلوي",
                              "البطن السفلي",
                              "الارداف",
                              "الفخذ الايسر",
                              "الفخذ الايمن",
                              "السمانة اليسرى",
                              "السمانة اليمنى"]
                    setupTableView2()
                }

            }
        }
    }
    
    func setupTableView1() {
        tableView1.dataSource = self
        tableView1.delegate = self
        tableView1.register(UINib(nibName: "BodyMCell", bundle: nil), forCellReuseIdentifier: "BodyMCell")
        tableView1.reloadData()
    }
    
    func setupTableView2() {
        tableView2.dataSource = self
        tableView2.delegate = self
        tableView2.register(UINib(nibName: "BodyM2Cell", bundle: nil), forCellReuseIdentifier: "BodyM2Cell")
        tableView2.reloadData()
    }
    
    @IBAction func btnAddBody(_ sender: Any) {
        guard let nextVc = AddBodyMeasurmentsVC.storyboardInstance() else {return}
        self.Vc?.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    
}


extension BodyCell : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array0.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1{
            let cell = tableView1.dequeueReusableCell(withIdentifier: "BodyMCell", for: indexPath) as? BodyMCell
                cell?.lbl.text = "\(array0[indexPath.row])"
            cell?.selectionStyle = .none
            return cell!
        }
        let cell2 = tableView2.dequeueReusableCell(withIdentifier: "BodyM2Cell", for: indexPath) as? BodyM2Cell
            cell2?.lbl.text = "\(array1[indexPath.row])"
        cell2?.selectionStyle = .none
        return cell2!
    }
    
}
