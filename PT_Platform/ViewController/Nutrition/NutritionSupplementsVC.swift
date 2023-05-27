//
//  NutritionSupplementsVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 31/01/2022.
//

import UIKit
import LanguageManager_iOS


class NutritionSupplementsVC: UIViewController {
    
    var datalist = [NewsfeedM]()
    var datalistRecipes = [RecipesM]()
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
            txtSearch.textAlignment = .right
        }
        txtSearch.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnSubBack
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            getSupplementsdata()
        }else{
            getRecipesdata()
        }
    }
    
    func getSupplementsdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.supplementsApi { category, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = category
                self.collectionView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: "Sothing wrong")
            }

        }
    }
    func getRecipesdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.recipesApi { category, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalistRecipes = category
                self.collectionView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: "Sothing wrong")
            }
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            Shared.shared.search = "?title=\(newString)"
            getSupplementsdata()
        }else{
            Shared.shared.search = "?name=\(newString)"
            getRecipesdata()
        }
    }
    
    

}
extension NutritionSupplementsVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if txtSearch.text?.isEmpty == false {
            
        }

    }

     //MARK:-  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let aString = txtSearch.text!
        let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            Shared.shared.search = "?title=\(newString)"
            getSupplementsdata()
        }else{
            Shared.shared.search = "?name=\(newString)"
            getRecipesdata()
        }
        return true
    }
}


extension NutritionSupplementsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 , height: 205)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            return datalist.count
        }
        return datalistRecipes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            cell?.lbl.text = datalist[indexPath.row].title as? String
            cell?.img.sd_setImage(with: URL(string:datalist[indexPath.row].image as! String), placeholderImage:UIImage(named: ""))
        }else{
            cell?.lbl.text = datalistRecipes[indexPath.row].title as? String
            cell?.img.sd_setImage(with: URL(string:datalistRecipes[indexPath.row].image as! String), placeholderImage:UIImage(named: ""))
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Shared.shared.btnSubBack == "Supplements" || Shared.shared.btnSubBack == "المكملات"{
            Shared.shared.NewsImage = datalist[indexPath.row].image as! String
            Shared.shared.NewsTitle = datalist[indexPath.row].title as! String
            Shared.shared.NewsDescription = datalist[indexPath.row].description as! String
            let controller = storyboard.instantiateViewController(withIdentifier: "News2VC") as! News2VC
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            Shared.shared.NewsImage = datalistRecipes[indexPath.row].image as! String
            Shared.shared.NewsTitle = datalistRecipes[indexPath.row].title as! String
            Shared.shared.NewsDescription = datalistRecipes[indexPath.row].description as! String
            Shared.shared.RecipesName = datalistRecipes[indexPath.row].name as! String
            Shared.shared.RecipesTime = "\(datalistRecipes[indexPath.row].time as! Int)"
            Shared.shared.RecipesIngredients = datalistRecipes[indexPath.row].ingredient as! String
            let controller = storyboard.instantiateViewController(withIdentifier: "RecipesVC") as! RecipesVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
