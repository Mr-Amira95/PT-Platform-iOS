//
//  NewsVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 23/01/2022.
//

import UIKit
import SDWebImage
import LanguageManager_iOS


class NewsVC: UIViewController {

    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    var datalist = [NewsfeedM]()
    {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        getnewsdata()
        lblBack.text = Shared.shared.btnBack
    }
    func getnewsdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.Newsfeed { category, bool in
            Spinner.instance.removeSpinner()
            if category.count != 0{
                self.datalist = category
                self.tableView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: "Data Empty")
            }
        }
    }
@IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
}
extension NewsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        cell?.selectionStyle = .none
        cell?.subtitle.text = datalist[indexPath.row].title as? String
        let des = datalist[indexPath.row].description as? String ?? ""
        cell?.Newstitle.isHidden = true
        cell?.Newsimage.sd_setImage(with: URL(string:datalist[indexPath.row].image as! String), placeholderImage:UIImage(named: ""))
      return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.NewsImage = datalist[indexPath.row].image as! String
        Shared.shared.NewsTitle = datalist[indexPath.row].title as! String
        Shared.shared.NewsDescription = datalist[indexPath.row].description as! String
        Shared.shared.notificationType = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "News2VC") as! News2VC
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension String{
    var HTmlToString: String?{
        guard let data = data(using: .utf8)else{return nil}
        do{
            return try NSAttributedString(data: data, options: [.documentType:NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil).string
        }
        catch _ as NSError{return nil}
    }
}
