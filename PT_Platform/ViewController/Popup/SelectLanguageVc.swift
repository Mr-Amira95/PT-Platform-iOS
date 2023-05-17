//
//  SelectLanguageVc.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 15/11/2022.
//

import UIKit
import LanguageManager_iOS


class SelectLanguageVc: UIViewController {
    var flag = "En"
    
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblArabic: UILabel!
    
    static func storyboardInstance() -> SelectLanguageVc? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SelectLanguageVc") as? SelectLanguageVc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
            let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
            var attrString = NSAttributedString(string: "English", attributes:attributes)
            lblEnglish.attributedText = attrString
        }else{
            let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
            let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
            var attrString = NSAttributedString(string: "عربي", attributes:attributes)
            lblArabic.attributedText = attrString
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped))
            self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

    }
    
    @objc func touchTapped() {
        self.dismiss(animated: true, completion: nil)
        }
    @IBAction func btnX(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnEnglish(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "هل أنت متأكد أنك تريد تغيير اللغة؟", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "نعم", style: UIAlertAction.Style.default, handler: { _ in
            self.SetEn()
        }))
        alert.addAction(UIAlertAction(title: "لا", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnArabic(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to change the language?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            self.SetAr()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func SetAr() {
        Shared.shared.saveUserLanguage(active: "ar")
        let selectLanguage: Languages = .ar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        LanguageManager.shared.setLanguage(language: selectLanguage, rootViewController: viewController) { (view) in
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
            if Shared.shared.getusertype() == "Coach"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "IntroVC")
                self.present(controller, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ManTabBar")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    
    func SetEn() {
        Shared.shared.saveUserLanguage(active: "en")
        let selectLanguage: Languages = .en
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        LanguageManager.shared.setLanguage(language: selectLanguage, rootViewController: viewController) { (view) in
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
            if Shared.shared.getusertype() == "Coach"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "IntroVC")
                self.present(controller, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ManTabBar")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }


}
