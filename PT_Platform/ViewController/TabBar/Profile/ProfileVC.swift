//
//  ProfileVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/01/2022.
//

import UIKit
import LanguageManager_iOS
import OneSignal

class ProfileVC: ImagePicker, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var btnEditName: UIButton!
    @IBOutlet weak var imgLogout: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if LanguageManager.shared.currentLanguage == .en{
            btnEditImage.setImage(UIImage(named: "IconEdit"), for: .normal)
            btnEditName.setImage(UIImage(named: "IconEdit"), for: .normal)
            imgLogout.image = UIImage(named: "IconExit")
        }else{
            btnEditImage.setImage(UIImage(named: "IconEditAr"), for: .normal)
            btnEditName.setImage(UIImage(named: "IconEditAr"), for: .normal)
            imgLogout.image = UIImage(named: "IconExitAr")
        }
        if Shared.shared.getusertype() != "Coach"{
            btnBack.isHidden = true
            imgBtnBack.isHidden = true
        }
        lblNameUser.text = "\(Shared.shared.getfirst_name() ?? "") \(Shared.shared.getlast_name() ?? "")"
        lblEmailUser.text = Shared.shared.getEmail() ?? ""
        imgUser.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        imgUser.layer.borderWidth = 5
        imgUser.layer.cornerRadius = 50
        if Shared.shared.getAvatar() ?? "" != ""{
            self.imgUser.sd_setImage(with: URL(string: Shared.shared.getAvatar() ?? ""), completed: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataName), name: NSNotification.Name(rawValue: "reloadDataName"), object: nil)
    }
    
    @objc func reloadDataName() {
        lblNameUser.text = "\(Shared.shared.getfirst_name() ?? "") \(Shared.shared.getlast_name() ?? "")"
        }
    
    override func SelectedImage(image: UIImage) {
        self.imgUser.image = image
    }
 
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgBtnBack: UIImageView!
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblEmailUser: UILabel!
    @IBAction func btnAssignedCoaches(_ sender: Any) {

    }
    
    @IBAction func btnEditImage(_ sender: Any) {
        Open()
    }
    
    @IBAction func btnEditName(_ sender: Any) {
        guard let nextVc = EditNamePopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnProgress(_ sender: Any) {
        Shared.shared.btnBack = "Progress"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProgressVC")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnSubscriptions(_ sender: Any) {
        Shared.shared.btnBack = "Subscriptions"
        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShopCheckoutVC")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteMyAccount(_ sender: Any) {
        deleteAccoutn()
    }
    
    @IBAction func btnSettings(_ sender: Any) {

    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        logout()
    }
    
    func logout() {
        let deviceState = OneSignal.getDeviceState()
        let pleyerId = deviceState?.userId
        let Parameter = ["device_player_id":pleyerId ?? 0] as [String:Any]
        ControllerService.instance.logoutApi(param: Parameter) { (message, bool) in
            if bool{
                Shared.shared.isLogin(auth: false)
                Shared.shared.saveid(auth: "")
                Shared.shared.saveCoachId(auth: 0)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "TellUsVC")
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    func deleteAccoutn(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the account?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Please, enter your password"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let parameter = ["password" : textField?.text ?? "",
                             "device_player_id" : Shared.shared.device_player_id ?? 0] as [String : Any]
            if textField?.text ?? "" == ""{
                self.Alert1(Message: "Please, enter your password")
            }else{
                ControllerService.instance.deleteMyAccountApi(param: parameter) { message, bool in
                    if bool{
                        Shared.shared.isLogin(auth: false)
                        Shared.shared.saveid(auth: "")
                        Shared.shared.saveCoachId(auth: 0)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TellUsVC")
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true, completion: nil)
                        
                    }else{
                        self.Alert1(Message: message)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func Alert1(Message: String){
        let alert = UIAlertController(title: "Whoops", message:Message , preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        self.present(alert,animated: true,completion: nil)
    }
    
}
