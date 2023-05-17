//
//  Q3Cell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 02/02/2022.
//

import UIKit

class Q3Cell: UITableViewCell {
    
    
    @IBOutlet weak var btnDone: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDone(_ sender: Any) {
    }
    
    
}
