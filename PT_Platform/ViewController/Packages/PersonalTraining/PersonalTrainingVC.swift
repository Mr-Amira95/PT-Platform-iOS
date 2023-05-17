//
//  PersonalTrainingVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 01/02/2022.
//

import UIKit

class PersonalTrainingVC: UIViewController {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "PackagesCell", bundle: nil), forCellWithReuseIdentifier: "PackagesCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(item: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
    }
   
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension PersonalTrainingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280 , height: 475)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesCell", for: indexPath) as? PackagesCell
        collectionView.selectItem(at: [1], animated: false, scrollPosition: .centeredHorizontally)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Packages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShopCheckoutVC")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    

}

