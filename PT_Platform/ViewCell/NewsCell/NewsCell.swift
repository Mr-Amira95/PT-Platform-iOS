//
//  NewsCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var Newsimage: UIImageView!
    @IBOutlet weak var Newstitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var days: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
