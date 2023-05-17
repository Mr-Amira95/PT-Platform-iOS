//
//  PackagesCell2.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 14/09/2022.
//

import UIKit

class PackagesCell2: UICollectionViewCell {
    
    
    @IBOutlet weak var FoodPlanLbl: UILabel!
    @IBOutlet weak var WorkoutScheduleLbl: UILabel!
    @IBOutlet weak var VideocallasLbl: UILabel!
    @IBOutlet weak var PackagesDescLbl: UILabel!
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
