//
//  PackagesCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 01/02/2022.
//

import UIKit

class PackagesCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblPackageDis: UILabel!
    @IBOutlet weak var lblPackagePrice: UILabel!
    @IBOutlet weak var lblPackageDate: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnButNow: UIButton!
    @IBOutlet weak var lblStartAndEndDateBuy: UILabel!
    
    
    var Vc : ShopVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
