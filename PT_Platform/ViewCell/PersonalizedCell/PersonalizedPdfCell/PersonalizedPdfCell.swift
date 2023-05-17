//
//  PersonalizedPdfCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 15/09/2022.
//

import UIKit

class PersonalizedPdfCell: UITableViewCell {
    
    var Vc3 : PersonalTrainingVideoVC?
    var DatalistPdf : [PersonalizedPdfM] = []
    
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
        self.DatalistPdf = Shared.shared.PersonalizedPdfMMArray as! [PersonalizedPdfM]
    }
    
}

extension PersonalizedPdfCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110 , height: 110)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatalistPdf.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as? MasterCell
        cell?.self.img.image = UIImage(named: "PdfIcon")
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = DatalistPdf[indexPath.row].value
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalizedPdfVC") as! PersonalizedPdfVC
        controller.pdfData = data as? String ?? ""
        self.Vc3?.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
