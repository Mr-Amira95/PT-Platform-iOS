//
//  HistoryListVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 29/05/2022.
//

import UIKit
import LanguageManager_iOS

class HistoryListVC: UIViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWorkoutHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WorkoutHistoryVC") as! WorkoutHistoryVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnExerciseHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ExerciseHistoryVC") as! ExerciseHistoryVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnNutritionHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NutritionHistoryVC") as! NutritionHistoryVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
