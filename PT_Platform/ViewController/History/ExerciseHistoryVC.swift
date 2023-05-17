//
//  ExerciseHistoryVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 31/05/2022.
//

import UIKit
import LanguageManager_iOS

class ExerciseHistoryVC: UIViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var datalist : [VideoM] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        getExercisesHistory()
    }
    
    func getExercisesHistory() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.exercisesHistoryApi { history, bool in
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
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ExerciseHistoryCell", bundle: nil), forCellReuseIdentifier: "ExerciseHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ExerciseHistoryVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseHistoryCell", for: indexPath) as? ExerciseHistoryCell
        if datalist[indexPath.row].image == ""{
            cell?.img.image = UIImage(named: "Trainer")
        }else{
            cell?.img.sd_setImage(with: URL(string: datalist[indexPath.row].image), completed: nil)
        }
        cell?.lblName.text = datalist[indexPath.row].title
            cell!.selectionStyle = .none
            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVc = DetailsExercisesHistoryPopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
        nextVc.getExercisesHistory(id: "\(datalist[indexPath.row].id)", name: datalist[indexPath.row].title)
    }
    
}
