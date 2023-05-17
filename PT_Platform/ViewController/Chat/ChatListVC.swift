//
//  ChatListVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 01/02/2022.
//

import UIKit

class ChatListVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
