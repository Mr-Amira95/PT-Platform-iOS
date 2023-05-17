//
//  TotalCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 03/02/2022.
//

import UIKit

class TotalCell: UITableViewCell {

    
    @IBOutlet weak var CartTotal: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CartTotal.text = Shared.shared.packagePrice
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
