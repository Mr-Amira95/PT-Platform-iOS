//
//  QuestionsCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 18/08/2022.
//

import UIKit

class QuestionsCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txtAnswer: UITextField!
    
    
    func setData(data: QuestionsM){
        lblQuestion.text = data.question as? String ?? ""
        txtAnswer.text = data.answer as? String ?? ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
