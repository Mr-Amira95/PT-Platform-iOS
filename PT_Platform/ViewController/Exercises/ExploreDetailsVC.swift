//
//  ExploreDetailsVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 30/01/2022.
//

import UIKit
import LanguageManager_iOS

class ExploreDetailsVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDisc: UITextView!
    @IBOutlet weak var img: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = Shared.shared.exercise_name
        lblDisc.text = Shared.shared.exercise_description
        img.sd_setImage(with: URL(string: Shared.shared.exercise_img), completed: nil)
        if LanguageManager.shared.currentLanguage == .ar{
            lblDisc.textAlignment = .right
        }
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: NSNotification.Name(rawValue: "back"), object: nil)
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnX(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnExplore(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailsCellVC") as! DetailsCellVC
        controller.type = 1
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}
