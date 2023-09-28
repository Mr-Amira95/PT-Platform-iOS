//
//  HomePageTraineeVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 04/01/2022.
//

import UIKit
import ImageSlideshow
import LanguageManager_iOS

struct Model1 {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
}

class HomePageTraineeVC: UIViewController {
    var datalist = [BannersM]()
    var impArray = [SDWebImageSource]()
    var models1 = [Model1]()
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HomePageCoachCell", bundle: nil), forCellWithReuseIdentifier: "HomePageCoachCell")
        }
    }
    @IBOutlet weak var sliderView: ImageSlideshow!{
        didSet{
            sliderView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            sliderView.addGestureRecognizer(gestureRecognizer)
            sliderView.contentMode = .scaleToFill
            sliderView.contentScaleMode = .scaleToFill
            sliderView.clipsToBounds = true
            sliderView.slideshowInterval = 4
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        Shared.shared.bannerIn = "first"
        addData1()
        getdataBaneer()
    }
    
    func addData1() {
        if LanguageManager.shared.currentLanguage == .en{
            models1.append(Model1(text: "Follow Us", imageName: "FollowUs"))
            models1.append(Model1(text: "Coaches", imageName: "Coach"))
            models1.append(Model1(text: "Contact Us", imageName: "ContacUS"))
            models1.append(Model1(text: "News", imageName: "News"))
            models1.append(Model1(text: "Nutrition", imageName: "Icon3-1"))
            models1.append(Model1(text: "Progress", imageName: "Icon4-1"))
        }else{
            models1.append(Model1(text: "تابعنا", imageName: "FollowUs"))
            models1.append(Model1(text: "مدربينك", imageName: "Coach"))
            models1.append(Model1(text: "تواصل معنا", imageName: "ContacUS"))
            models1.append(Model1(text: "أخبار", imageName: "News"))
            models1.append(Model1(text: "التغذية", imageName: "Icon3-1"))
            models1.append(Model1(text: "التطور", imageName: "Icon4-1"))
        }
    }
    func getData(){
        for image in datalist {
            impArray.append(SDWebImageSource(urlString:  "\(image.image)", placeholder: UIImage(named: "FITNESS-1"))!)
        }
        sliderView?.setImageInputs(impArray)
    }
    func getdataBaneer(){
        ControllerService.instance.Banner { category, bool in
            if bool{
                self.datalist = category
                self.getData()

            }
        }
    }
    @objc func didTap() {
        let typeUrl = datalist[sliderView.currentPage].url as? String ?? ""
        if typeUrl == "" {
            sliderView.presentFullScreenController(from: self)
        }else{
            if let url = URL(string: typeUrl) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
    }
    
}


extension HomePageTraineeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCoachCell", for: indexPath) as? HomePageCoachCell
        cell?.SetData(data: models1[indexPath.row])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Shared.shared.btnBack = models1[indexPath.row].text
        if models1[indexPath.row].text == "Contact Us" || models1[indexPath.row].text == "تواصل معنا"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ContactUsVC")
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models1[indexPath.row].text == "Follow Us" || models1[indexPath.row].text == "تابعنا"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FollowUsVC")
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models1[indexPath.row].text == "News" || models1[indexPath.row].text == "أخبار"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewsVC")
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models1[indexPath.row].text == "Coaches" || models1[indexPath.row].text == "مدربينك"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChooswTrainerVC")
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
//            if let tabBarController = tabBarController{
//                tabBarController.selectedIndex = 1
//            }
        }else if models1[indexPath.row].text == "Nutrition" || models1[indexPath.row].text == "التغذية"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NutritionVC") as! NutritionVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models1[indexPath.row].text == "Progress" || models1[indexPath.row].text == "التطور"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProgressVC") as! ProgressVC
            self.navigationController?.pushViewController(controller, animated: true)
        }

        
        
    }
    

}
