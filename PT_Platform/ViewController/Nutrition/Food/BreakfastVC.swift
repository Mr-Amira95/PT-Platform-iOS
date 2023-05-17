//
//  BreakfastVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 01/06/2022.
//

import UIKit

class BreakfastVC: UIViewController {

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnRecipes: UIButton!
    @IBOutlet weak var btnMeals: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAll(_ sender: Any) {
        btnAll.backgroundColor = UIColor(named: "MainColor")
        btnRecipes.backgroundColor = nil
        btnMeals.backgroundColor = nil
    }
    
    @IBAction func btnRecipes(_ sender: Any) {
        btnAll.backgroundColor = nil
        btnRecipes.backgroundColor = UIColor(named: "MainColor")
        btnMeals.backgroundColor = nil
    }
    
    @IBAction func btnMeals(_ sender: Any) {
        btnAll.backgroundColor = nil
        btnRecipes.backgroundColor = nil
        btnMeals.backgroundColor = UIColor(named: "MainColor")
    }
    
}
