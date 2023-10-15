//
//  ListFoodPopupVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 16/11/2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListFoodPopupVC: UIViewController, UITextFieldDelegate {
    
    var dataList = [FoodsM]()
    var foodId = 0
    var  Vc : AddFoodVC?
    var countOfProducts = 0
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    static func storyboardInstance() -> ListFoodPopupVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ListFoodPopupVC") as? ListFoodPopupVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = Shared.shared.FoodListMArray as! [FoodsM]
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(named: "MainColor")
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(Done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtSearch.inputAccessoryView = toolBar
        txtSearch.delegate = self
        
        countOfProducts = dataList.count
        Shared.shared.Skip = 1
        setupTableView()
    }
    
    @objc func Done() {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        countOfProducts = 0
        dataList.removeAll()
        moreData()
        self.view.endEditing(true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FoodListCell", bundle: nil), forCellReuseIdentifier: "FoodListCell")
        tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        countOfProducts = 0
        dataList.removeAll()
        moreData()
    }
    func getFoods(){
        ControllerService.instance.FoodsApi { foods, bool in
            if bool{
                self.dataList = foods
                self.setupTableView()
                Shared.shared.FoodListMArray = foods as NSArray
            }
        }
    }
    
    @IBAction func btnSelect(_ sender: Any) {
        if !dataList.isEmpty{
            Shared.shared.FoodListMArray = dataList as NSArray
        }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFoodInAddFoodVC"), object: nil)
            self.dismiss(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        Shared.shared.search = "?name=\(newString)"
        countOfProducts = 0
        dataList.removeAll()
        moreData()
        self.view.endEditing(true)
        return true
    }
    

}


extension ListFoodPopupVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as? FoodListCell
        cell?.lbl.text = dataList[indexPath.row].name
        cell?.mainView.layer.borderColor = UIColor.white.cgColor
        cell?.mainView.layer.borderWidth = 1
        cell?.mainView.layer.cornerRadius = 5
        cell?.lbl.font = cell?.lbl.font.withSize(13)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.FoodListId = indexPath.row
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        let lastItem = dataList.count - 1
        if indexPath.item == lastItem {
            if Shared.shared.Skip == 1{
                moreData()
            }else if Shared.shared.Skip == 0{
                Shared.shared.Skip = 1
            }else if Shared.shared.Skip == 2{
                
            }
        }
      }
    }
    
    func moreData(){
           var Datalist : [FoodsM] = []
        let headers2: HTTPHeaders = ["Accept":"application/json",
                                    "Authorization":"Bearer \(Shared.shared.getUserToken() ?? "")",
                                     "Accept-Language": Shared.shared.getUserLanguage() ?? "en"]
        var url = ""
        if Shared.shared.search == ""{
            url = "\(foods_url)?skip=\(countOfProducts)"
        }else{
            url = "\(foods_url)\(Shared.shared.search)&skip=\(countOfProducts)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).responseJSON {
               (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 || statusCode == 422 {
                   switch response.result {
                   case .success(let value):
                       let dic = response.value as! NSDictionary
                       let errors = dic["errors"] as Any
                       let success = dic["success"] as? NSNumber
                       if success == 1{
                           let data = dic["data"] as! [[String:Any]]
                           if data.count == 0 {
                               Shared.shared.Skip = 2
                           }else{
                               for data2 in data{
                                   let id = data2["id"] as? Int ?? 0
                                   let sku = data2["sku"] as? String ?? ""
                                   let calorie = data2["calorie"] as? String ?? ""
                                   let carb = data2["carb"] as? String ?? ""
                                   let fat = data2["fat"] as? String ?? ""
                                   let protein = data2["protein"] as? String ?? ""
                                   let name = data2["name"] as? String ?? ""
                                   let title = data2["title"] as? String ?? ""
                                   
                                   let obj = FoodsM(id: id, sku: sku, calorie: calorie, carb: carb, fat: fat, protein: protein, name: name, title: title)
                                   self.dataList.append(obj)
                                   Shared.shared.Skip = 1
                                   self.countOfProducts = +self.dataList.count
                               }
                               self.tableView.reloadData()
                           }
                       }else{
//                           complition(Datalist, false)
                       }
                   case .failure(let error):
                       print(error)
                   }
               }
            }
        }
    
}
