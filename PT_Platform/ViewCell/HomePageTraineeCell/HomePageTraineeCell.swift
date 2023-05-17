//
//  HomePageTraineeCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 04/01/2022.
//

import UIKit

class HomePageTraineeCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    func SetData(data: Model1) {
        self.lbl.text = data.text
        self.img.image = UIImage(named: data.imageName)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
