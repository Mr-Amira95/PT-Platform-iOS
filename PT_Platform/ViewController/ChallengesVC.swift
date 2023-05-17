//
//  ChallengesVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit
import LanguageManager_iOS

class ChallengesVC: UIViewController {
    
    var datalist = [ChallengesM]()
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
        setupTableView()
        getChallengesdata()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ChallengeCell", bundle: nil), forCellReuseIdentifier: "ChallengeCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getChallengesdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.ChallengesApi { Fav, message, bool, bool2  in
            Spinner.instance.removeSpinner()
            if bool{
                if bool2{
                    self.datalist = Fav
                    self.tableView.reloadData()
                }else{
                    ToastView.shared.short(self.view, txt_msg: message)
                }
            }else{
                Shared.shared.btnBack = "Authorized"
                let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ChallengesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as? ChallengeCell
        cell?.setData(data: datalist[indexPath.row])
        cell?.btnDescription.tag = indexPath.row
        cell?.btnDescription.addTarget(self, action: #selector(btnNote(_:)), for: .touchUpInside)
            cell!.selectionStyle = .none
            return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Shared.shared.challenge_id = datalist[indexPath.row].id
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChallengedCompleteVC") as! ChallengedCompleteVC
            self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func btnNote(_ sender:UIButton){
        Alert(Title: "Description", Message: datalist[sender.tag].description)
    }
    
    func Alert (Title: String,Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
