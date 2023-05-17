//
//  PersonalTrainingVideoVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 10/08/2022.
//

import UIKit
import LanguageManager_iOS

class PersonalTrainingVideoVC: UIViewController {
    
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPersonalised: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    let arrayChallenges = ["Assigned Workouts","Assigned Meals"]
    let arrayPersonalized = ["Video","Image","Notes"]
    let arrayChallengesAr = ["المجموعات المخصصة","الوجبات المخصصة"]
    let arrayPersonalizedAr = ["فيديو","صورة","ملاحظات"]
    var DatalistVideo : [PersonalizedVideoM] = []
    var DatalistImage : [PersonalizedImageM] = []
    var DatalistPdf : [PersonalizedPdfM] = []
    var flag = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(Authorized), name: NSNotification.Name(rawValue: "Authorized"), object: nil)
    }
    
    @objc func Authorized() {
        Shared.shared.btnBack = "Authorized"
        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
        self.navigationController?.pushViewController(controller, animated: true)
        }

    func setupTableView() {
        tableView.register(UINib(nibName: "ExercisesCell1", bundle: nil), forCellReuseIdentifier: "ExercisesCell1")
        tableView.register(UINib(nibName: "ExercisesCell2", bundle: nil), forCellReuseIdentifier: "ExercisesCell2")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func setupPersonalizedTableView() {
        tableView.register(UINib(nibName: "PersonalizedVideoCell", bundle: nil), forCellReuseIdentifier: "PersonalizedVideoCell")
        tableView.register(UINib(nibName: "PersonalizedImageCell", bundle: nil), forCellReuseIdentifier: "PersonalizedImageCell")
        tableView.register(UINib(nibName: "PersonalizedPdfCell", bundle: nil), forCellReuseIdentifier: "PersonalizedPdfCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getData(){
        ControllerService.instance.trainingPersonalApi { video, image, pdf, bool in
            if bool{
                Shared.shared.PersonalizedVideoMArray = video as NSArray
                Shared.shared.PersonalizedImageMArray = image as NSArray
                Shared.shared.PersonalizedPdfMMArray = pdf as NSArray
                self.setupPersonalizedTableView()
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome(_ sender: Any) {
        flag = "Home"
        btnHome.backgroundColor = UIColor(named: "MainColor")
        btnPersonalised.backgroundColor = .clear
        setupTableView()
    }
    
    @IBAction func btnPersonalised(_ sender: Any) {
        flag = "Personalized"
        btnHome.backgroundColor = .clear
        btnPersonalised.backgroundColor = UIColor(named: "MainColor")
        getData()
    }
    

}



extension PersonalTrainingVideoVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if flag == "Personalized"{
            return 3
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flag == "Personalized"{
            return 170
        }
        return 250
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if LanguageManager.shared.currentLanguage == .en{
            if flag == "Personalized"{
                if indexPath.section == 0{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedVideoCell", for: indexPath) as? PersonalizedVideoCell {
                            cell.lblTitle.text = arrayPersonalized[0]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedImageCell", for: indexPath) as? PersonalizedImageCell {
                            cell.lblTitle.text = arrayPersonalized[1]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 2{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedPdfCell", for: indexPath) as? PersonalizedPdfCell {
                            cell.lblTitle.text = arrayPersonalized[2]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }
            }else{
                if indexPath.section == 0{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesCell1", for: indexPath) as? ExercisesCell1 {
                            cell.lblTitle.text = arrayChallenges[0]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesCell2", for: indexPath) as? ExercisesCell2 {
                            cell.lblTilte.text = arrayChallenges[1]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }
            }
        }else{
            if flag == "Personalized"{
                if indexPath.section == 0{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedVideoCell", for: indexPath) as? PersonalizedVideoCell {
                            cell.lblTitle.text = arrayPersonalizedAr[0]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedImageCell", for: indexPath) as? PersonalizedImageCell {
                            cell.lblTitle.text = arrayPersonalizedAr[1]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 2{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalizedPdfCell", for: indexPath) as? PersonalizedPdfCell {
                            cell.lblTitle.text = arrayPersonalizedAr[2]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }
            }else{
                if indexPath.section == 0{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesCell1", for: indexPath) as? ExercisesCell1 {
                            cell.lblTitle.text = arrayChallengesAr[0]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }else if indexPath.section == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesCell2", for: indexPath) as? ExercisesCell2 {
                            cell.lblTilte.text = arrayChallengesAr[1]
                            cell.selectionStyle = .none
                            cell.Vc3 = self
                            return cell
                        }
                    }
            }
        }

        return UITableViewCell()
    }
}
