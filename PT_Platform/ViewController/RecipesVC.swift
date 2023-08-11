//
//  RecipesVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit
import LanguageManager_iOS

class RecipesVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblIngredients: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
            lblDescription.textAlignment = .left
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            lblDescription.textAlignment = .right
        }
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnSubBack
        lblTitle2.text = Shared.shared.RecipesName
        lblName.text = Shared.shared.NewsTitle
        img.sd_setImage(with: URL(string:Shared.shared.NewsImage), placeholderImage:UIImage(named: ""))
        lblDescription.text = Shared.shared.NewsDescription
        lblTime.text = Shared.shared.RecipesTime
        lblIngredients.text = Shared.shared.RecipesIngredients
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SourceInfo", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SourceInfoViewController") as! SourceInfoViewController
        controller.type = .recipesandDietPlans
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
}
