//
//  FeedbackVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit
import LanguageManager_iOS

class FeedbackVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtMessage: UITextView! {
        didSet {
            txtMessage.backgroundColor = .white
        }
    }
    @IBOutlet weak var lblBtnBack: UILabel!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
            lblBtnBack.text = Shared.shared.btnBack
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            txtTitle.textAlignment = .right
            txtMessage.textAlignment = .right
            lbl.textAlignment = .right
            if Shared.shared.btnBack == "Feedback"{
                lblBtnBack.text = "ارسل ملاحظتك"
            }else{
                lblBtnBack.text = "الدعم الفني"
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSend(_ sender: Any) {
        if Shared.shared.btnBack == "Feedback"{
            feedback()
        }else{
            technicalSupport()
        }
    }
    
    func feedback(){
        let parameter = ["subject" : txtTitle.text!,
                         "message" : txtMessage.text!]
        ControllerService.instance.feedbackPost(param: parameter) { message, bool in
            if bool{
                self.txtTitle.text = ""
                self.txtMessage.text = ""
                ToastView.shared.short(self.view, txt_msg: "Send successfuly")
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func technicalSupport(){
        let parameter = ["subject" : txtTitle.text!,
                         "message" : txtMessage.text!]
        ControllerService.instance.technicalSupportPost(param: parameter) { message, bool in
            if bool{
                self.txtTitle.text = ""
                self.txtMessage.text = ""
                ToastView.shared.short(self.view, txt_msg: "Send successfuly")
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    

}
