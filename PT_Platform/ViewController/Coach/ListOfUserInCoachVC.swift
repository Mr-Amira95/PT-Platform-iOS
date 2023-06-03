//
//  ListOfUserInCoachVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 27/09/2022.
//

import UIKit
import LanguageManager_iOS

class ListOfUserInCoachVC: UIViewController {
    var datalist = [TrainingPersonalCoachM]()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        }
    }
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnBack: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        getdata()
        btnBack.text = "Choose your trainee"
        txtSearch.delegate = self
    }
    
    func getdata(){
        Shared.shared.listOfCoach = "users"
        ControllerService.instance.personalTraningCoachPage { data, message, bool in
            if bool{
                self.datalist = data
                self.collectionView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    

    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        getdata()
    }
    
}

extension ListOfUserInCoachVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtSearch.text?.isEmpty == false {
            
        }

    }

     //MARK:-  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        getdata()
        return true
    }
}

extension ListOfUserInCoachVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        cell?.lbl.text = "\(datalist[indexPath.item].name as? String ?? "name")"
        cell?.img.sd_setImage(with: URL(string:datalist[indexPath.row].avatar as? String ?? "avatar"), placeholderImage:UIImage(named: "CoachDefaultIcon"))
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Shared.shared.selectUserInCoach = datalist[indexPath.row].id as? Int ?? 0
        Shared.shared.selectUserInCoachName = datalist[indexPath.row].name as? String ?? ""
        if Shared.shared.enterListUser == "Progress"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProgressVC") as! ProgressVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.enterListUser == "Questions"{
            let storyboard = UIStoryboard(name: "Questions", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "QuestionsVC") as! QuestionsVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.enterListUser == "History"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HistoryListVC") as! HistoryListVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.enterListUser == "Live Chat"{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: nil)
        }else if Shared.shared.enterListUser == "Challenges"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChallengesVC") as! ChallengesVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

