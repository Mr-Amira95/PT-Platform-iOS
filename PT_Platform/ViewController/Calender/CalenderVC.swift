//
//  CalenderVC.swift
//  PT_Platform
//
//  Created by mustafa khallad on 28/08/2022.
//

import UIKit
import LanguageManager_iOS

class CalenderVC: UIViewController {

    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgCoach: UIImageView!
    @IBOutlet weak var lblCoach: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
            lblCoach.text = "\(Shared.shared.getCoachName() ?? "") Availabilty:"
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            lblCoach.text = "\(Shared.shared.getCoachName() ?? "") :متاح"
            lblCoach.textAlignment = .right
        }
        setupTableView()
        let image = Shared.shared.getCoachImage()
        self.imgCoach.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "CoachDefaultIcon"))
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "CalenderCell", bundle: nil), forCellReuseIdentifier: "CalenderCell")
        tableView.register(UINib(nibName: "AvailableTableCell", bundle: nil), forCellReuseIdentifier: "AvailableTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if Shared.shared.calendarTimeId == 0{
            ToastView.shared.short(self.view, txt_msg: "Please select time")
        }else{
            let parameter = ["time_id" : Shared.shared.calendarTimeId]
            Spinner.instance.showSpinner(onView: view)
            ControllerService.instance.reservationPost(param: parameter) { created_at, duration1, join_url, message, bool, bool2 in
                Spinner.instance.removeSpinner()
                if bool  && bool2{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "RequestSentVC") as! RequestSentVC
                    controller.created_at = created_at
                    controller.duration1 = duration1
                    controller.join_url = join_url
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    if bool2{
                        ToastView.shared.short(self.view, txt_msg: message)
                    }else{
                        Shared.shared.btnBack = "Authorized"
                        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        }
        
    }
    

}


extension CalenderVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 317
        }
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell", for: indexPath) as? CalenderCell {
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableTableCell", for: indexPath) as? AvailableTableCell {
                cell.selectionStyle = .none
                cell.Vc = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
