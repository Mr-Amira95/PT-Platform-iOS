//
//  FoodListCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 17/11/2022.
//

import UIKit

class FoodListCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
