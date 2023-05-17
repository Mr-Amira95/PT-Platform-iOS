//
//  DetailsExercisesHistoryCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 19/11/2022.
//

import UIKit

class DetailsExercisesHistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWight: UILabel!
    @IBOutlet weak var lblSet: UILabel!
    @IBOutlet weak var btnNote: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
