//
//  ChallengeCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit

class ChallengeCell: UITableViewCell {
    
    @IBOutlet weak var lblTitleChallenge: UILabel!
    @IBOutlet weak var imgChallenge: UIImageView!
    @IBOutlet weak var btnDescription: UIButton!
    
    
    func setData(data: ChallengesM){
        lblTitleChallenge.text = data.title
        imgChallenge.sd_setImage(with: URL(string: data.icon), placeholderImage:UIImage(named: "News1"))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        btnDescription.layer.borderWidth = 1
        btnDescription.layer.borderColor = UIColor(named: "MainColor")?.cgColor
    }

    
}
