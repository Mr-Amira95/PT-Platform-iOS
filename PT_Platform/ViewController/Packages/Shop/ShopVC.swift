//
//  ShopVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit
import LanguageManager_iOS

class ShopVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgBack: UIImageView!
    
    var datalist = [PackegeSubscriptionM]()
    var datalistPT = [PackegePTM]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
        getPackeges()
    }
    
    func setCollectionView(){
        collectionView.register(UINib(nibName: "CollectionPackagesCell", bundle: nil), forCellWithReuseIdentifier: "CollectionPackagesCell")
        collectionView.register(UINib(nibName: "CollectionPackagesPTCell", bundle: nil), forCellWithReuseIdentifier: "CollectionPackagesPTCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func getPackeges(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.PackagesApi { subscription, pt, bool in
            Spinner.instance.removeSpinner()
            if bool{
                if subscription.count == 0 && pt.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No packeges")
                }else{
                    self.datalist = subscription
                    for i in self.datalist{
                        if i.is_shop{
                            for ii in self.datalist{
                                ii.can_shop = false
                            }
                        }
                    }
                    Shared.shared.subscriptionMArray = self.datalist as NSArray
                    self.datalistPT = pt
                    for i in self.datalistPT{
                        if i.is_shop{
                            for ii in self.datalistPT{
                                ii.can_shop = false
                            }
                        }
                    }
                    Shared.shared.pTMArray = self.datalistPT as NSArray
                    self.setCollectionView()
                }
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ShopVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPackagesCell", for: indexPath) as? CollectionPackagesCell
            if LanguageManager.shared.currentLanguage == .en{
                cell?.lblTitle.text = "Subscriptions"
            }else{
                cell?.lblTitle.text = "الاشتراكات"
            }
            cell?.Vc = self
            return cell!
        }
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPackagesPTCell", for: indexPath) as? CollectionPackagesPTCell
            if LanguageManager.shared.currentLanguage == .en{
                cell?.lblTitle.text = "PT Packages"
            }else{
                cell?.lblTitle.text = "باقات المدرب الشخصي"
            }
            cell?.Vc = self
            return cell!
        }
        return UICollectionViewCell()
    }

    
}

