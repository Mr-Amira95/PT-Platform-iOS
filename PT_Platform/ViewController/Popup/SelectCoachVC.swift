//
//  SelectCoachVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 29/08/2022.
//

import UIKit

class SelectCoachVC: UIViewController {
    
    var datalistCoaches = [UserscoachesM]()

    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "CoachCell", bundle: nil), forCellReuseIdentifier: "CoachCell")
        }
    }
    
    static func storyboardInstance() -> SelectCoachVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SelectCoachVC") as? SelectCoachVC
    }

        
    override func viewDidLoad() {
        super.viewDidLoad()
        datalistCoaches = Shared.shared.coachMArray as! [UserscoachesM]
        self.tableView.reloadData()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}


extension SelectCoachVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalistCoaches.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachCell", for: indexPath) as? CoachCell
        cell?.lblNameCoach.text = "\(datalistCoaches[indexPath.row].last_name as? String ?? "")"
      return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.saveCoachName(auth: "\(self.datalistCoaches[0].last_name)")
        Shared.shared.saveCoachImage(auth: datalistCoaches[indexPath.row].avatar)
        Shared.shared.saveCoachId(auth: datalistCoaches[indexPath.row].id)
    }
}
