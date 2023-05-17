//
//  ExercisesSearchVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 06/10/2022.
//

import UIKit
import LanguageManager_iOS


class ExercisesSearchVC: UIViewController {
    
    var datasection = [HomeexerciseDataM]()
    var dataList = [ChallengesM]()
    var search = ""
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        txtSearch.delegate = self
        txtSearch.text = search
        if Shared.shared.btnBack == "Exercises"{
            getExercisesSearchdata()
        }else if Shared.shared.btnBack == "Workouts"{
            getWorkoutsdata()
        }
    }
    
    func getExercisesSearchdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.ExerciseSearchApi { search, message, bool  in
            Spinner.instance.removeSpinner()
            if bool{
                self.dataList = search
                self.setCollectioView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func getWorkoutsdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.WorkoutsSearchApi { search, message, bool  in
            Spinner.instance.removeSpinner()
            if bool{
                self.dataList = search
                self.setCollectioView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }

    
    func setCollectioView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        self.collectionView.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?search=\(newString)"
        if Shared.shared.btnBack == "Exercises"{
            getExercisesSearchdata()
        }else if Shared.shared.btnBack == "Workouts"{
            getWorkoutsdata()
        }

    }
    
}

extension ExercisesSearchVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtSearch.text?.isEmpty == false {
            
        }
    }

     //MARK:-  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?search=\(newString)"
        if Shared.shared.btnBack == "Exercises"{
            getExercisesSearchdata()
        }else if Shared.shared.btnBack == "Workouts"{
            getWorkoutsdata()
        }
        return true
    }
}

extension ExercisesSearchVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 , height: 205)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        let Exercis = dataList[indexPath.row]
        cell?.lbl.text = Exercis.title as? String ?? ""
        let image = Exercis.icon as? String ?? ""
        if image == ""{
            cell?.self.img.image = UIImage(named: "Trainer")
        }else{
            cell?.self.img.sd_setImage(with: URL(string: image), completed: nil)
        }
            return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let Exercis = dataList[indexPath.row]
            Shared.shared.exercise_id = Exercis.id as? Int ?? 0
            Shared.shared.exercise_name = Exercis.title as? String ?? ""
            Shared.shared.exercise_description = Exercis.description as? String ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavDetailsCellVC")
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
    }
}
