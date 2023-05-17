//
//  CollectionPackagesCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit
import LanguageManager_iOS

class CollectionPackagesCell: UICollectionViewCell {
    
    var datalist = [PackegeSubscriptionM]()
    var Vc : ShopVC?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "PackagesCell", bundle: nil), forCellWithReuseIdentifier: "PackagesCell")
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        datalist = Shared.shared.subscriptionMArray as! [PackegeSubscriptionM]
    }

}


extension CollectionPackagesCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200 , height: 375)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesCell", for: indexPath) as? PackagesCell
        let package = datalist[indexPath.row]
        if package.style == "style_gold"{
            cell?.imgBackground.image = UIImage(named: "PackageGold")
        }else if package.style == "style_bronze"{
            cell?.imgBackground.image = UIImage(named: "PackageBronze")
        }else if package.style == "style_silver"{
            cell?.imgBackground.image = UIImage(named: "PackageSilver")
        }else if package.style == "style_free"{
            cell?.imgBackground.image = UIImage(named: "FITNESS-1")
        }
    
        cell?.lblPackageName.text = package.name
        cell?.lblPackageDis.text = package.description
        cell?.lblPackagePrice.text = package.price
        cell?.lblStartAndEndDateBuy.text = package.startAndEndDate
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
        if package.is_free{
            Checkout(package_id: "\(package.id)")
        }else{
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
                Shared.shared.packageFeatures = ""
                Shared.shared.packagePurchaseAppleId = package.purchase_apple_id
                Shared.shared.packageIsFree = package.is_free
                Shared.shared.btnBack = "Subscriptions"
                let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ShopCheckoutVC")
                controller.modalPresentationStyle = .fullScreen
                Vc?.present(controller, animated: true, completion: nil)
            }
        }

    }
    
    
    func Checkout(package_id: String) {
            var parameter = ["package_id" : package_id,
                         "payment_method":"free",
                         "coach_id":"\(Shared.shared.getCoachId() ?? 0)"]
        Spinner.instance.showSpinner(onView: (Vc?.view)!)
        ControllerService.instance.packagePost(param: parameter) { data, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.Alert(Message: "Enjoy most of our life-changing features for free and start paving your way to a healthier life!")

            }else{
                ToastView.shared.short((self.Vc?.view)!, txt_msg: data)
            }
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Your Free Trial Has Started", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ManTabBar")
            controller.modalPresentationStyle = .fullScreen
            self.Vc?.present(controller, animated: true, completion: nil)
        }))
        Vc?.present(alert, animated: true, completion: nil)
    }


}
