//
//  TellUsVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 03/01/2022.
//

import UIKit

class TellUsVC: UIViewController {
    
    @IBOutlet weak var viewCoach: UIView!
    @IBOutlet weak var viewTrainee: UIView!
    @IBOutlet weak var imgCoach: UIImageView!
    @IBOutlet weak var imgTrainee: UIImageView!
    
    var Flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        viewCoach.layer.cornerRadius = 10
        viewCoach.layer.borderWidth = 2
        viewCoach.layer.borderColor = UIColor(named: "MainColor")?.cgColor

        viewTrainee.layer.cornerRadius = 10
        viewTrainee.layer.borderWidth = 2
        viewTrainee.layer.borderColor = UIColor(named: "MainColor")?.cgColor
    }

    @IBAction func btnCoach(_ sender: Any) {
        Flag = 1
        imgCoach.image = UIImage(named: "IconSelect")
        imgTrainee.image = UIImage(named: "IconUnSelect")
        Shared.shared.setusertype(auth: "Coach")
    }
    
    @IBAction func btnTrainee(_ sender: Any) {
        Flag = 2
        imgCoach.image = UIImage(named: "IconUnSelect")
        imgTrainee.image = UIImage(named: "IconSelect")
        Shared.shared.setusertype(auth: "User")
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        if Flag == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInAfterSignUPVC") as! SignInAfterSignUPVC
            self.present(vc, animated: true, completion: nil)
        }else if Flag == 2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.present(vc, animated: true, completion: nil)
        }else{
           Alert(Message: "Please select about you!")
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Ooops!", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
