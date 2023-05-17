//
//  ExercisesVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 27/01/2022.
//

import UIKit
import LanguageManager_iOS

class ExercisesVC: UIViewController {
    
    var datasection = [HomeexerciseDataM]()
    var dataList = [CategoryM]()
    var groupId = 0
    var selectedIndex = 0

    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "GroupCell", bundle: nil), forCellWithReuseIdentifier: "GroupCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            txtSearch.textAlignment = .right
        }
        lblTitle.text = Shared.shared.btnBack
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        if Shared.shared.btnBack == "Exercises" || Shared.shared.btnBack == "تمارين"{
            getDataExercies()
        }else if Shared.shared.btnBack == "Workouts" || Shared.shared.btnBack == "مجموعات"{
            getDataWorkout()
        }else if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if Shared.shared.btnBack == "Authorized"{
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    func setupTableView() {
        tableView.register(UINib(nibName: "ExercisesCell1", bundle: nil), forCellReuseIdentifier: "ExercisesCell1")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?search=\(newString)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ExercisesSearchVC") as! ExercisesSearchVC
        controller.search = txtSearch.text!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCross(_ sender: Any) {
        groupId = 2
        getDataExercies()
        btnCross.backgroundColor = UIColor.init(named: "MainColor")
        btnHome.backgroundColor = nil
    }
    @IBAction func btnHome(_ sender: Any) {
        groupId = 4
        getDataExercies()
        btnCross.backgroundColor = nil
        btnHome.backgroundColor = UIColor.init(named: "MainColor")
    }
    func getDataExercies(){
        ControllerService.instance.ExerciseHomePage { category, bool, bool2 in
            if bool && bool2{
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "Empty data")
                }else{
                    self.datasection = category
                    Shared.shared.group_id = category[0].id
                    self.getCategoryExercies()
                    self.collectionView.reloadData()
                }
            }else{
                if bool2{
                    ToastView.shared.short(self.view, txt_msg: "message")
                }else{
                    Shared.shared.btnBack = "Authorized"
                    let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    func getCategoryExercies()  {
        Spinner.instance.showSpinner(onView: view)
        self.dataList = []
        ControllerService.instance.categoryExercise { category, message, bool, bool2  in
            Spinner.instance.removeSpinner()
            if bool && bool2{
                self.dataList = category
                self.tableView.reloadData()
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
    func getDataWorkout(){
        ControllerService.instance.WorkoutHomePage { category, bool, bool2 in
            if bool && bool2{
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "Empty data")
                }else{
                    self.datasection = category
                    Shared.shared.group_id = category[0].id
                    self.getCategoryWorkout()
                    self.collectionView.reloadData()
                }
            }else{
                if bool2{
                    ToastView.shared.short(self.view, txt_msg: "message")
                }else{
                    Shared.shared.btnBack = "Authorized"
                    let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                    self.navigationController?.pushViewController(controller, animated: true)
                }

            }
        }
    }
    func getCategoryWorkout()  {
        self.dataList = []
        ControllerService.instance.categoryWorkout { category, message, bool  in
            if bool{
                self.dataList = category
                self.tableView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    
    
}


extension ExercisesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesCell1", for: indexPath) as? ExercisesCell1 {
        cell.lblTitle.text = dataList[indexPath.row].title as? String ?? ""
        cell.model = dataList[indexPath.row]
        cell.Vc = self
        cell.selectionStyle = .none
        return cell
    }
        return UITableViewCell()
    }
}

extension ExercisesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasection.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell
        let CatName = self.datasection[indexPath.row].title as? String ?? ""
        let boldAttribute = [
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!
        ]
        let regularAttribute = [
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        ]
        let boldText = NSAttributedString(string: "  \(CatName as? String ?? "")  ", attributes: boldAttribute)
        let regularText = NSAttributedString(string: "  \(CatName as? String ?? "")  ", attributes: regularAttribute)
        let newString = NSMutableAttributedString()
        cell?.lbl.textColor = .white
        cell?.lbl.layer.cornerRadius = 17.5
        cell?.lbl.layer.masksToBounds = true
        if selectedIndex == indexPath.item{
            newString.append(boldText)
            cell?.lbl.backgroundColor = UIColor(named: "MainColor")
        }else{
            newString.append(regularText)
            cell?.lbl.backgroundColor = .clear
        }
        cell?.lbl.attributedText = newString
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataList = []
        self.tableView.reloadData()
        self.selectedIndex = indexPath.item
        Shared.shared.group_id = datasection[indexPath.item].id
        if Shared.shared.btnBack == "Exercises" || Shared.shared.btnBack == "تمارين"{
            getCategoryExercies()
        }else if Shared.shared.btnBack == "Workouts" || Shared.shared.btnBack == "مجموعات"{
            getCategoryWorkout()
        }
        self.collectionView.reloadData()
    }
    
}
