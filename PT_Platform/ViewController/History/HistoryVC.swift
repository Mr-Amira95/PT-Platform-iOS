//
//  HistoryVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 01/02/2022.
//

import UIKit
import ImageSlideshow
import LanguageManager_iOS

class HistoryVC: UIViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCell")
        }
    }
    
    var datalist = [VideoM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = Shared.shared.btnBack
        if Shared.shared.btnBack == "Favorites" || Shared.shared.btnBack == "المفضلة"{
            getFavouritesdata()
        }else if Shared.shared.btnBack == "Today’s Workout" || Shared.shared.btnBack == "تمارين اليوم"{
            let currentDateTime = Date()
            let userCalendar = Calendar.current
            let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
            let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
            Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
            getWorkoutdata()
        }
    }
    
    
    func getFavouritesdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.FavouritesVideoPage { Fav, message, bool  in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = Fav
                self.collectionView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func getWorkoutdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.WorkoutTodayVideoPage { Workout, message, bool  in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = Workout
                self.collectionView.reloadData()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
        cell?.lbl.text = datalist[indexPath.item].title
        cell?.img.sd_setImage(with: URL(string: datalist[indexPath.item].image), completed: nil)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Favourites = datalist[indexPath.row]
        Shared.shared.video_id = Favourites.id
        Shared.shared.imgFav = Favourites.image
        Shared.shared.urlFav = Favourites.video
        Shared.shared.titleFav = Favourites.title
        Shared.shared.descriptionFav = Favourites.description
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavDetailsCellVC")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)

    }
}
