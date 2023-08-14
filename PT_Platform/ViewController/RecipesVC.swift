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
    
    @IBOutlet weak var textViewIngredients: UITextView! {
        didSet {
//            textViewIngredients.isSelectable = false
        }
    }
    @IBOutlet weak var textViewDescription: UITextView! {
        didSet {
//            textViewDescription.isSelectable = false
        }
    }

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
        
        textViewDescription.attributedText = Shared.shared.NewsDescription.htmlToAttributedString
        let string = NSMutableAttributedString(attributedString: textViewDescription.attributedText)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        string.addAttributes(attributes, range: (string.string as NSString).range(of: string.string))
        textViewDescription.attributedText = string
        textViewDescription.textColor = .white
        lblTime.text = Shared.shared.RecipesTime
        
        textViewIngredients.attributedText = Shared.shared.RecipesIngredients.htmlToAttributedString
        let string2 = NSMutableAttributedString(attributedString: textViewIngredients.attributedText)
        let attributes2 = [NSAttributedString.Key.foregroundColor: UIColor.red]
        string2.addAttributes(attributes2, range: (string2.string as NSString).range(of: string2.string))
        textViewIngredients.attributedText = string2
        textViewIngredients.textColor = .white
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


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
