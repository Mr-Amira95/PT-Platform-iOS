//
//  AssignedCoachesVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/01/2022.
//

import UIKit
import LanguageManager_iOS


class AssignedCoachesVC: UIViewController {
    
    var datalist = [UserscoachesM]()
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        getAssignedCoach()
    }
    
    
    func getAssignedCoach(){
        let parameter = ["skip" : "0",
                         "filter" : "assigned_coaches"]
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.assignedcoaches(param: parameter) { assigned, message, bool1, bool2  in
            Spinner.instance.removeSpinner()
            if bool1{
                if bool2{
                    self.datalist = assigned
                    self.collectionView.reloadData()
                }else{
                    ToastView.shared.short(self.view, txt_msg: "No assigned coaches to show")
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

extension AssignedCoachesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        cell?.SetData(data: datalist[indexPath.row])
        return cell!
    }
    
}
