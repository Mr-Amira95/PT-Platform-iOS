//
//  ChooswTrainerVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 25/01/2022.
//

import UIKit
import SDWebImage
import LanguageManager_iOS

class ChooswTrainerVC: UIViewController {
    var datalist = [UserscoachesM]()
    
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        }
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        getdata()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .ar{
            txtSearch.textAlignment = .right
        }
        txtSearch.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
    }

    func getdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.userscoaches { category, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                self.collectionView.reloadData()
            }
        }
    }
}
extension ChooswTrainerVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtSearch.text?.isEmpty == false {
            
        }

    }

     //MARK:-  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        getdata()
        return true
    }
}

extension ChooswTrainerVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        cell?.lbl.text = "\(datalist[indexPath.item].last_name)"
        cell?.img.sd_setImage(with: URL(string:datalist[indexPath.row].avatar), placeholderImage:UIImage(named: "CoachDefaultIcon"))
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if datalist[indexPath.item].is_subscription {
            Shared.shared.saveCoachName(auth: "\(datalist[indexPath.item].last_name)")
            Shared.shared.saveCoachImage(auth: datalist[indexPath.item].logo)
            Shared.shared.saveCoachId(auth: datalist[indexPath.item].id)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomePageCoachVC")
            let nav = UINavigationController(rootViewController: controller)
            if let tabBarController = self.tabBarController {
                var updatedViewControllers = tabBarController.viewControllers
                updatedViewControllers?[1] = nav
                updatedViewControllers?[1].tabBarItem.title = "Coach"
                tabBarController.selectedViewController?.tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], for: .normal)
                tabBarController.viewControllers = updatedViewControllers
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
        }else{
            let storyboard = UIStoryboard(name: "Packages", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
            controller.coachId = datalist[indexPath.item].id
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
}

extension ChooswTrainerVC {
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }

}
