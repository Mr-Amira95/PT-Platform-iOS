//
//  PersonalizedImageVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 29/11/2022.
//

import UIKit

class PersonalizedImageVC: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    
    var imgData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img.sd_setImage(with: URL(string: imgData), completed: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
