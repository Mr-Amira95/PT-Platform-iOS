//
//  VideoChatCoachVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/09/2022.
//

import UIKit
import LanguageManager_iOS

class VideoChatCoachVC: UIViewController {
    var datalist = [VideoChatCoachM]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTableViewUser: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var tableViewUser: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        if Shared.shared.getusertype() == "Coach"{
            viewTableViewUser.isHidden = true
            getdataCoach()
        }else{
            viewTableViewUser.isHidden = false
            getdataUser()
        }
    }
    
    func getdataCoach(){
        ControllerService.instance.videoChatCoachPage { videoChat, message, bool in
            if bool{
                if videoChat.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No data")
                }else{
                    self.datalist = videoChat
                    self.setupTableView()
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func getdataUser(){
        ControllerService.instance.videoChatUserPage { videoChat, message, bool in
            if bool{
                if videoChat.count == 0{
                    self.datalist = []
                    self.setupTableViewUser()
                    ToastView.shared.short(self.view, txt_msg: "No data")
                }else{
                    self.datalist = videoChat
                    self.setupTableViewUser()
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "VideoChatCoachCell", bundle: nil), forCellReuseIdentifier: "VideoChatCoachCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func setupTableViewUser() {
        tableViewUser.register(UINib(nibName: "VideoChatUserCell", bundle: nil), forCellReuseIdentifier: "VideoChatUserCell")
        tableViewUser.delegate = self
        tableViewUser.dataSource = self
        tableViewUser.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension VideoChatCoachVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewUser{
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChatUserCell", for: indexPath) as? VideoChatUserCell
            cell?.lblName.text = Shared.shared.getCoachName()
            cell?.lblDateTime.text = "\(datalist[indexPath.row].dateLink as? String ?? "dateLink") / \(datalist[indexPath.row].timeLink as? String ?? "timeLink")"
            cell?.btnJion.tag = indexPath.row
            cell?.btnJion.addTarget(self, action: #selector(btnJion(_:)), for: .touchUpInside)
            cell?.btnCancel.tag = indexPath.row
            cell?.btnCancel.addTarget(self, action: #selector(btnCancel(_:)), for: .touchUpInside)
                cell!.selectionStyle = .none
                return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChatCoachCell", for: indexPath) as? VideoChatCoachCell
        cell?.lblName.text = datalist[indexPath.row].nameUser as? String ?? "name"
        cell?.lblTime.text = "\(datalist[indexPath.row].dateLink as? String ?? "dateLink") / \(datalist[indexPath.row].timeLink as? String ?? "timeLink")"
        cell?.btnJion.tag = indexPath.row
        cell?.btnJion.addTarget(self, action: #selector(btnJion(_:)), for: .touchUpInside)
            cell!.selectionStyle = .none
            return cell!
    }
    
    
    @objc func btnJion(_ sender:UIButton){
        let videoChatLink = datalist[sender.tag].startLink as? String ?? ""
        let alert = UIAlertController(title: "Join Session", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            if let url = URL(string: videoChatLink) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func btnCancel(_ sender:UIButton){
        let reservation = datalist[sender.tag]
        let parameter = ["id":reservation.id]
        let alert = UIAlertController(title: "Delete Session", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            ControllerService.instance.cancelReservationPost(param: parameter) { message, bool in
                if bool{
                    ToastView.shared.short(self.view, txt_msg: "Cancel successfuly")
                    self.getdataUser()
                }else{
                    ToastView.shared.short(self.view, txt_msg: message)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    


}
