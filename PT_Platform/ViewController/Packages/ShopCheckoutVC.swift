//
//  ShopCheckoutVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit
//import StoreKit
import LanguageManager_iOS

class ShopCheckoutVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblPackageDes: UILabel!
    @IBOutlet weak var lblPackageFeatures2: UILabel!
    @IBOutlet weak var lblPackageFeatures: UILabel!
    
    @IBOutlet weak var viewPromoCode: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        if Shared.shared.packageIsFree == true{
            viewPromoCode.isHidden = true
        }
        lblTitle.text = Shared.shared.btnBack
        lblPackageName.text = Shared.shared.packageName
        lblDuration.text = Shared.shared.packageDuration
        lblPrice.text = Shared.shared.packagePrice
        lblPackageDes.text = Shared.shared.packageDes
        lblPackageFeatures.text = Shared.shared.packageFeatures
        lblPackageFeatures2.text = "Package features\n"

    }
    private func payRequest() {
        Spinner.instance.showSpinner(onView: view)
        var parameter = [:] as [String:Any]
        parameter = ["package_id" : Shared.shared.packageId,
                     "payment_method":"stripe",
                     "coach_id":"\(Shared.shared.getCoachId() ?? 0)"]
        
        ControllerService.instance.packagePost(param: parameter) { data, bool in
            Spinner.instance.removeSpinner()
            if bool {
                let storyboard = UIStoryboard(name: "WebViewSB", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController
                controller?.url = data
                controller?.modalPresentationStyle = .fullScreen
                self.present(controller!, animated: true, completion: nil)
            } else {
                ToastView.shared.short(self.view, txt_msg: data)
            }
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCheckout(_ sender: Any) {
        payRequest()
    }
}
