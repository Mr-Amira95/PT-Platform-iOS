//
//  PersonalizedImageCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 15/09/2022.
//

import UIKit

class PersonalizedImageCell: UITableViewCell {
    
    var Vc3 : PersonalTrainingVideoVC?
    var DatalistImage : [PersonalizedImageM] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "MasterCell", bundle: nil), forCellWithReuseIdentifier: "MasterCell")
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.DatalistImage = Shared.shared.PersonalizedImageMArray as! [PersonalizedImageM]
    }
    
}

extension PersonalizedImageCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110 , height: 110)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatalistImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as? MasterCell
        let images = DatalistImage[indexPath.row]
        let image = images.value as? String ?? ""
        if image == ""{
            cell?.self.img.image = UIImage(named: "Trainer")
        }else{
            cell?.self.img.sd_setImage(with: URL(string: image), completed: nil)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = DatalistImage[indexPath.row].value
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalizedImageVC") as! PersonalizedImageVC
        controller.imgData = data as? String ?? ""
        self.Vc3?.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
}
