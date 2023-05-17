//
//  TrainerCell.swift
//  PT_Platform
//
//  Created by QTechnetworks on 25/01/2022.
//

import UIKit
import SDWebImage


class TrainerCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    
    
    var model:ExercisesInM!{
        didSet{
            lbl.text = model.title as? String ?? ""
            let image = model.icon as? String ?? ""
            if image == ""{
                self.img.image = UIImage(named: "CoachDefaultIcon")
            }else{
                self.img.sd_setImage(with: URL(string: image), completed: nil)
            }
        }
    }
    

    
    func SetData(data: UserscoachesM) {
        self.lbl.text = data.last_name
        img.sd_setImage(with: URL(string:data.avatar), placeholderImage:UIImage(named: "CoachDefaultIcon"))
    }
    
    func SetData(data: Model6) {
        self.lbl.text = data.text
        self.img.image = UIImage(named: data.imageName)
    }
    
    func SetData(data: ChallengesVideoM) {
        self.lbl.text = data.title
        img.sd_setImage(with: URL(string: data.image), placeholderImage:UIImage(named: "CoachDefaultIcon"))
        if data.image != ""{
            imgVideo.isHidden = true
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        btnCheck.isHidden = true
        imgVideo.isHidden = true
        btnCheck.layer.borderWidth = 1
        btnCheck.layer.borderColor = UIColor(named: "MainColor")?.cgColor
    }

}
