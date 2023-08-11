//
//  News2VC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit
import SDWebImage
import LanguageManager_iOS


class News2VC: UIViewController {
    
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var DescribtionImg: UIImageView!
    @IBOutlet weak var DesTitleTxt: UILabel!
    @IBOutlet weak var DescrebtionTxt: UITextView!
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            DescrebtionTxt.textAlignment = .right
        }
        
        if Shared.shared.btnBack == "Nutrition"{
            lblBack.text = Shared.shared.btnSubBack
        }else{
            lblBack.text = Shared.shared.btnBack
        }
        
        if Shared.shared.notificationType == "news_feed"{
            getDataForNotification()
        }else{
            DescribtionImg.sd_setImage(with: URL(string:Shared.shared.NewsImage), placeholderImage:UIImage(named: "Recipes"))
            DesTitleTxt.text = Shared.shared.NewsTitle
            let data2 = Shared.shared.NewsDescription
            let attrStr = try! NSAttributedString(data: data2.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
            self.DescrebtionTxt.attributedText = attrStr
            self.DescrebtionTxt.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
            self.DescrebtionTxt.textColor = .white
            
            
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SourceInfo", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SourceInfoViewController") as! SourceInfoViewController
        controller.type = .supplements
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
    func getDataForNotification(){
        ControllerService.instance.NewsfeedForNotification { id, title, description, image, bool in
            if bool{
                self.DescribtionImg.sd_setImage(with: URL(string:image), placeholderImage:UIImage(named: "Recipes"))
                self.DesTitleTxt.text = title
                let data = Data(description.utf8)
                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    self.DescrebtionTxt.attributedText = attributedString
                    self.DescrebtionTxt.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
                    self.DescrebtionTxt.textColor = .white
                }
            }
        }
    }
    

    
    
    
}
