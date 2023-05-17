//
//  DetailsExercisesHistoryPopupVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 19/11/2022.
//

import UIKit
import LanguageManager_iOS

class DetailsExercisesHistoryPopupVC: UIViewController {

    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var datalist = [exercisesHistoryDetailsM]()
    var Vc : ExerciseHistoryVC?
    
    static func storyboardInstance() -> DetailsExercisesHistoryPopupVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DetailsExercisesHistoryPopupVC") as? DetailsExercisesHistoryPopupVC
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DetailsExercisesHistoryCell", bundle: nil), forCellReuseIdentifier: "DetailsExercisesHistoryCell")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func getExercisesHistory(id:String, name:String) {
        self.lblExerciseName.text = name
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.exercisesHistoryDetailsApi(id: id) { history, bool in
            Spinner.instance.removeSpinner()
            if bool{
                if history.count == 0{
                    self.datalist = []
                }else{
                    self.datalist = history
                }
                self.setupTableView()
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
extension DetailsExercisesHistoryPopupVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsExercisesHistoryCell", for: indexPath) as? DetailsExercisesHistoryCell
        let history = datalist[indexPath.row]
        cell?.lblDate.text = history.created_at as? String ?? ""
        cell?.lblWight.text = "\(history.weight) \(history.weight_unit)"
        cell?.lblSet.text = "\(history.repetition)"
        cell?.btnNote.tag = indexPath.row
        cell?.btnNote.addTarget(self, action: #selector(btnNote(_:)), for: .touchUpInside)
            return cell!
    }
    
    @objc func btnNote(_ sender:UIButton){
        Alert(Title: "Note", Message: datalist[sender.tag].note as? String ?? "")
    }
    
    func Alert (Title: String,Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
