//
//  CalenderCoachVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 25/09/2022.
//

import UIKit
import LanguageManager_iOS
import Alamofire
import SwiftyJSON

class CalenderCoachVC: UIViewController {
    var datalist = [CalenderCoachM]()
    var countOfProducts = 0
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.setupTableView()
        moreData()
        Shared.shared.Skip = 1
        
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "CalenderCoachCell", bundle: nil), forCellReuseIdentifier: "CalenderCoachCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CalenderCoachVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCoachCell", for: indexPath) as? CalenderCoachCell
        let calendar = datalist[indexPath.row]
        cell?.lblName.text = calendar.user_name as? String ?? "user_name"
        cell?.lblDate.text = calendar.date as? String ?? "date"
        cell?.lblTime.text = calendar.time as? String ?? "time"
        if calendar.status as? String ?? "status" == "accept"{
            cell?.lblStatus.text = "✔️"
        }else if calendar.status as? String ?? "status" == "pending"{
            cell?.lblStatus.text = calendar.status as? String ?? "status"
        }else if calendar.status as? String ?? "status" == "waiting"{
            cell?.lblStatus.text = calendar.status as? String ?? "status"
        }else{
            if LanguageManager.shared.currentLanguage == .en{
                cell?.lblStatus.text = "Status"
            }else{
                cell?.lblStatus.text = "الحالة"
            }
        }
            cell!.selectionStyle = .none
            return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        let lastItem = datalist.count - 1
        if indexPath.item == lastItem {
            if Shared.shared.Skip == 1{
                moreData()
            }else if Shared.shared.Skip == 0{
                Shared.shared.Skip = 1
            }else if Shared.shared.Skip == 2{

            }
        }
      }
    }
    
    func moreData(){
        Spinner.instance.showSpinner(onView: view)
        var Datalist : [CalenderCoachM] = []
     let headers2: HTTPHeaders = ["Accept":"application/json",
                                  "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                  "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
     Alamofire.request("\(calender_coach_url)?skip=\(countOfProducts)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
            (response) in
         Spinner.instance.removeSpinner()
            let statusCode = response.response?.statusCode
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = response.value as! NSDictionary
                    let errors = dic["errors"] as Any
                    let success = dic["success"] as? NSNumber
                    if success == 1{
                        let data = dic["data"] as! [[String:Any]]
                        if data.count == 0{
                            Shared.shared.Skip = 2
                        }else{
                            if self.countOfProducts == 0 {
                                if LanguageManager.shared.currentLanguage == .en{
                                    let obj1 = CalenderCoachM(id: 0, date: "Date", time: "Time", status: "Status", user_name: "Name", is_auto_accept: false)
                                    self.datalist.append(obj1)
                                }else{
                                    let obj1 = CalenderCoachM(id: 0, date: "التاريخ", time: "الوقت", status: "الحالة", user_name: "الإسم", is_auto_accept: false)
                                    self.datalist.append(obj1)
                                }
                            }
                            for data2 in data{
                                let id = data2["id"] as! Int
                                let date = data2["date"] as? String ?? "date"
                                let time = data2["time"] as? String ?? "time"
                                let status = data2["status"] as? String ?? "status"
                                let user_name = data2["user_name"] as? String ?? "user"
                                let is_auto_accept = data2["is_auto_accept"] as? Bool ?? false
                                let obj = CalenderCoachM(id: id, date: date, time: time, status: status, user_name: user_name, is_auto_accept: is_auto_accept)
                                self.datalist.append(obj)
                                Shared.shared.Skip = 1
                                self.countOfProducts = +self.datalist.count
                            }
                            self.tableView.reloadData()
                        }
                    }else{
                    }
                case .failure(let error):
                    print(error)
                }
            }
         }
        }
}
