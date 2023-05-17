//
//  HomePageCoachCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 25/01/2022.
//

import UIKit

class HomePageCoachCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    func SetData(data: Model3) {
        self.lbl.text = data.text
        self.img.image = UIImage(named: data.imageName)
    }
    
    func SetData(data: Model7) {
        self.lbl.text = data.text
        self.img.image = UIImage(named: data.imageName)
    }
    
    func SetData(data: Model1) {
        self.lbl.text = data.text
        self.img.image = UIImage(named: data.imageName)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
