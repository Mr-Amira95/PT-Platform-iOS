//
//  CollectionPackagesPTCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 04/09/2022.
//

import UIKit
import LanguageManager_iOS

class CollectionPackagesPTCell: UICollectionViewCell {
    
    var datalist = [PackegePTM]()
    var Vc : ShopVC?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "PackagesCell2", bundle: nil), forCellWithReuseIdentifier: "PackagesCell2")
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitleHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datalist = Shared.shared.pTMArray as! [PackegePTM]
        collectionViewHeight.constant = datalist.isEmpty ? 0.0 : 380.0
        lblTitleHeight.constant = datalist.isEmpty ? 0.0 : 38.0
        lblTitle.isHidden = datalist.isEmpty
    }
}

extension CollectionPackagesPTCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200 , height: 375)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesCell2", for: indexPath) as? PackagesCell2
        let package = datalist[indexPath.row]
        if package.style == "style_gold"{
            cell?.imgBackground.image = UIImage(named: "PackageGold")
        }else if package.style == "style_bronze"{
            cell?.imgBackground.image = UIImage(named: "PackageBronze")
        }else if package.style == "style_silver"{
            cell?.imgBackground.image = UIImage(named: "PackageSilver")
        }else {
            cell?.imgBackground.image = UIImage(named: "freepackages_bg")
        }
        cell?.lblPackageName.text = package.name
        cell?.lblPackageDis.text = package.description
        cell?.lblPackagePrice.text = package.price
        cell?.lblStartAndEndDateBuy.text = package.startAndEndDate
        
        cell?.VideocallasLbl.text = "Video call: \(datalist[indexPath.item].permissionsCallVideo)"
        cell?.WorkoutScheduleLbl.text = "Workout Schedule: \(datalist[indexPath.item].permissionsWorkoutSchedule)"
        cell?.FoodPlanLbl.text = "Food Plan: \(datalist[indexPath.item].permissionsFoodPlan)"
        
        if LanguageManager.shared.currentLanguage == .en{
            cell?.lblPackageDate.text = "\(Int(package.date)) months"
            if Shared.shared.getusertype() != "Coach"{
                cell?.btnButNow.tag = indexPath.row
                cell?.btnButNow.addTarget(self, action: #selector(btnButNow(_:)), for: .touchUpInside)
                if package.is_shop{
                    cell?.btnButNow.isEnabled = true
                    cell?.btnButNow.setTitle("Subscrip", for: .normal)
                }else{
                    if package.can_shop{
                        cell?.btnButNow.isEnabled = true
                        cell?.btnButNow.setTitle("Buy now", for: .normal)
                    }else{
                        cell?.btnButNow.isEnabled = false
                        cell?.btnButNow.setTitle("Can't Buy now", for: .normal)
                    }
                }
            }else{
                cell?.btnButNow.isHidden = true
            }
        }else{
            cell?.lblPackageDate.text = "\(Int(package.date)) شهور"
            if Shared.shared.getusertype() != "Coach"{
                cell?.btnButNow.tag = indexPath.row
                cell?.btnButNow.addTarget(self, action: #selector(btnButNow(_:)), for: .touchUpInside)
                if package.is_shop{
                    cell?.btnButNow.isEnabled = true
                    cell?.btnButNow.setTitle("مشترك", for: .normal)
                }else{
                    if package.can_shop{
                        cell?.btnButNow.isEnabled = true
                        cell?.btnButNow.setTitle("شراء الان", for: .normal)
                    }else{
                        cell?.btnButNow.isEnabled = false
                        cell?.btnButNow.setTitle("لا يمكنك الشراء", for: .normal)
                    }
                }
            }else{
                cell?.btnButNow.isHidden = true
            }
        }
        
        

        return cell!
    }
    
    @objc func btnButNow(_ sender:UIButton){
        let package = datalist[sender.tag]
        if package.is_shop{
            if LanguageManager.shared.currentLanguage == .en{
                ToastView.shared.short((Vc?.view)!, txt_msg: "you already have a package")
            }else{
                ToastView.shared.short((Vc?.view)!, txt_msg: "لديك بالفعل حزمة")
            }
        }else{
            Shared.shared.packageName = "\(package.name)\n"
            Shared.shared.packagePrice = package.price
            Shared.shared.packageDuration = "\(package.date) months"
            Shared.shared.packageDes = "\(package.description)\n"
            Shared.shared.packageId = "\(package.id)"
            Shared.shared.packagePurchaseAppleId = package.purchase_apple_id
            Shared.shared.packageFeatures = "Video call: \(package.permissionsCallVideo)\n\nWorkout Schedule: \(package.permissionsWorkoutSchedule)\n\nFood Plan: \(package.permissionsFoodPlan)\n"
            Shared.shared.btnBack = "PT Packages"
            let storyboard = UIStoryboard(name: "Packages", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ShopCheckoutVC")
            controller.modalPresentationStyle = .fullScreen
            Vc?.present(controller, animated: true, completion: nil)
        }

    }
    

}
