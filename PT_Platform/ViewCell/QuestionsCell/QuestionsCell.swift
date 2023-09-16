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
        guard let answer = data.answer else {return}
        guard let question = data.question else {return}
        lblQuestion.text = question
        txtAnswer.text = answer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
