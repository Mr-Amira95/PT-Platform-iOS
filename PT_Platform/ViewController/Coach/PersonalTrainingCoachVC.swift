//
//  PersonalTrainingCoachVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 24/09/2022.
//

import UIKit

class PersonalTrainingCoachVC: UIViewController {
    var datalist = [TrainingPersonalCoachM]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        getdata()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TrainingPersonalCoachCell", bundle: nil), forCellReuseIdentifier: "TrainingPersonalCoachCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getdata(){
        Shared.shared.listOfCoach = ""
        ControllerService.instance.personalTraningCoachPage { data, message, bool in
            if bool{
                let obj1 = TrainingPersonalCoachM(id: 0, avatar: "", name: "Username", start_date: "Start Date", end_date: "End Date", package_name: "Package", type: "Type")
                self.datalist.append(obj1)
                for i in data{
                    let obj1 = TrainingPersonalCoachM(id: i.id as? Int ?? 0, avatar: i.avatar as? String ?? "", name: i.name as? String ?? "", start_date: i.start_date as? String ?? "", end_date: i.end_date as? String ?? "", package_name: i.package_name as? String ?? "", type: i.type as? String ?? "")
                    self.datalist.append(obj1)
                }
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
}


extension PersonalTrainingCoachVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingPersonalCoachCell", for: indexPath) as? TrainingPersonalCoachCell
        cell?.lblName.text = datalist[indexPath.row].name as? String ?? "name"
        cell?.lblStartDate.text = datalist[indexPath.row].start_date as? String ?? "start_date"
        cell?.lblRenew.text = datalist[indexPath.row].end_date as? String ?? "end_date"
        if datalist[indexPath.row].type as? String ?? "type" == "subscription"{
            cell?.lblPackage.text = "\(datalist[indexPath.row].package_name as? String ?? "package_name") (Subscrip)"
        }else if datalist[indexPath.row].type as? String ?? "type" == "personal_training"{
            cell?.lblPackage.text = "\(datalist[indexPath.row].package_name as? String ?? "package_name") (P.T)"
        }
            cell!.selectionStyle = .none
            return cell!
    }
}
