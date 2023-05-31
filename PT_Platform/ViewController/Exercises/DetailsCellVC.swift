//
//  DetailsCellVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 28/01/2022.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage
import LanguageManager_iOS

class DetailsCellVC: UIViewController {
    
    var arrayDetalis: [String] = []
    var datalist : [VideoM] = []
    var url = ""
    var image = ""
    var counter = 0
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var dataDescription = ""

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVideos: UIImageView!
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var btnSeeMore: UIButton!
    
    @IBOutlet weak var btnAddToFavourite: UIButton!
    @IBOutlet weak var btnAddToTodayWorkout: UIButton!

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "Details2Cell", bundle: nil), forCellReuseIdentifier: "Details2Cell")
        }
    }
    var onAddRemoveFavourite: ((Bool) -> Void)?
    var onAddRemoveTodayWorkout: ((Bool) -> Void)?
    var isAddedToFav = false
    var isAddedToTodayWorkout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onAddRemoveFavourite = { [weak self] isAdded in
            let title = !isAdded ? "Add to favourites" : "Remove from favourites"
            self?.btnAddToFavourite.setTitle(title, for: .normal)
            self?.isAddedToFav = isAdded
        }
        onAddRemoveTodayWorkout = { [weak self] isAdded in
            let title = !isAdded ? "Add to today's workout" : "Remove from today's workout"
            self?.btnAddToTodayWorkout.setTitle(title, for: .normal)
            self?.isAddedToTodayWorkout = isAdded
        }
        if LanguageManager.shared.currentLanguage == .en{
            btnBack.setImage(UIImage(named: "btnBack"), for: .normal)
        }else{
            btnBack.setImage(UIImage(named: "btnBackAr"), for: .normal)
            txtDescription.textAlignment = .right
        }
        self.navigationController?.navigationBar.isHidden = true
        if  Shared.shared.getusertype() == "Coach" {
            btnsView.isHidden = true
            self.lblTitle.isHidden = true
        }
        lblTitle.text = Shared.shared.exercise_name
        dataDescription = Shared.shared.exercise_description
        let attrStr = try! NSAttributedString(data: dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
        self.txtDescription.attributedText = attrStr
        self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
        self.txtDescription.textColor = .white
        if dataDescription.count > 164{
            btnSeeMore.isHidden = false
        }else{
            self.btnSeeMore.isHidden = true
        }
        if Shared.shared.btnBack == "Exercises" || Shared.shared.btnBack == "تمارين"{
            getdata()
        }else if Shared.shared.btnBack == "Workouts" || Shared.shared.btnBack  == "مجموعات"{
            getdataWorkout()
        }else if Shared.shared.btnBack == "Log"{
            lblTitle.text = "2022-05-26"
            getdataLogs()
        }else if Shared.shared.btnBack == "Favorites" || Shared.shared.btnBack == "المفضلة"{
            self.lblTitle.isHidden = true
            self.counter = 0
            self.url = Shared.shared.urlFav
            self.video()
            self.imgVideos.sd_setImage(with: URL(string: Shared.shared.imgFav), completed: nil)
            txtDescription.text = Shared.shared.descriptionFav
            tableView.isHidden = true
        }else if Shared.shared.btnBack == "Today’s Workout" || Shared.shared.btnBack == "تمارين اليوم"{
            self.counter = 0
            self.url = Shared.shared.urlFav
            self.video()
            self.imgVideos.sd_setImage(with: URL(string: Shared.shared.imgFav), completed: nil)
            txtDescription.text = Shared.shared.descriptionFav
            tableView.isHidden = true
        }else if Shared.shared.btnBack == "Challenges" || Shared.shared.btnBack == "تحديات"{
            getdataChallenge()
            self.lblTitle.isHidden = true
        }else if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
//            getdataWorkout()
            getdataTrainingWorkout()
            self.lblTitle.isHidden = true
        }
        
    }
    

    
    @IBAction func btnBack(_ sender: Any) {
        avpController.player?.pause()
        self.dismiss(animated: true, completion: nil)
        if Shared.shared.btnBack == "Workouts" || Shared.shared.btnBack  == "مجموعات"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "back"), object: nil)
        }
       
    }
    
    @IBAction func PlayvideoBtn(_ sender: Any) {
        if url == ""{
            ToastView.shared.short(self.view, txt_msg: "Empty video")
        }else{
            let url = URL(string: "\(self.url)")!
            let player = AVPlayer(url: url)
                  let vc = AVPlayerViewController()
                  vc.player = player
                  self.present(vc, animated: true)
        }

    }
    func getdata() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.ExerciseVideoPage { category, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No video")
                }else{
                    self.onAddRemoveFavourite?((category[0].is_favourite != 0))
                    self.onAddRemoveTodayWorkout?((category[0].is_today_log != 0))
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.reloadData()
                    self.dataDescription = category[0].description
                    let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                    self.txtDescription.attributedText = attrStr
                    self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                    self.txtDescription.textColor = .white
                    if self.dataDescription.count > 164{
                        self.btnSeeMore.isHidden = false
                    }else{
                        self.btnSeeMore.isHidden = true
                    }
                }
            }
        }
    }
    func getdataChallenge() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.ChallengeVideoPage { category, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No video")
                }else{
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.isHidden = true
                    self.dataDescription = category[0].description
                    let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                    self.txtDescription.attributedText = attrStr
                    self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                    self.txtDescription.textColor = .white
                    if self.dataDescription.count > 164{
                        self.btnSeeMore.isHidden = false
                    }else{
                        self.btnSeeMore.isHidden = true
                    }
                }
            }
        }
    }
    func getdataTrainingWorkout() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.trainingWorkoutVideoPage { category, message, bool, bool1 in
            Spinner.instance.removeSpinner()
            if bool{
                if bool1{
                    self.datalist = category
                    if category.count == 0{
                        ToastView.shared.short(self.view, txt_msg: "No video")
                    }else{
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.reloadData()
                        self.dataDescription = category[0].description
                        let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                        self.txtDescription.attributedText = attrStr
                        self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                        self.txtDescription.textColor = .white
                        if self.dataDescription.count > 164{
                            self.btnSeeMore.isHidden = false
                        }else{
                            self.btnSeeMore.isHidden = true
                        }
                   }
                }else{
                    ToastView.shared.short(self.view, txt_msg: message)
                }
            }else{
                Shared.shared.btnBack = "Authorized"
                let storyboard = UIStoryboard(name: "Packages", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "NoAuthorizedVC") as! NoAuthorizedVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    func getdataWorkout() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.WorkoutVideoPage { category, message, bool, bool1 in
            Spinner.instance.removeSpinner()
            if bool{
                if bool1{
                    self.datalist = category
                    if category.count == 0{
                        ToastView.shared.short(self.view, txt_msg: "No video")
                    }else{
                        self.image = category[0].image
                        self.counter = 0
                        self.url = category[0].video
                        Shared.shared.video_id = category[0].id
                        self.onAddRemoveFavourite?((category[0].is_favourite != 0))
                        self.onAddRemoveTodayWorkout?((category[0].is_today_log != 0))
                        self.video()
                        self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                        self.tableView.reloadData()
                        self.dataDescription = category[0].description
                        let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                        self.txtDescription.attributedText = attrStr
                        self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                        self.txtDescription.textColor = .white
                        if self.dataDescription.count > 164{
                            self.btnSeeMore.isHidden = false
                        }else{
                            self.btnSeeMore.isHidden = true
                        }
                    }
                }else{
                    ToastView.shared.short(self.view, txt_msg: message)
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func getdataWorkoutToday() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.WorkoutTodayVideoPage { category, message, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No video")
                }else{
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.reloadData()
                    self.dataDescription = category[0].description
                    let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                    self.txtDescription.attributedText = attrStr
                    self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                    self.txtDescription.textColor = .white
                    if self.dataDescription.count > 164{
                        self.btnSeeMore.isHidden = false
                    }else{
                        self.btnSeeMore.isHidden = true
                    }
                }
            }
        }
    }
    func getdataLogs() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.LogsVideoPage { category, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No video")
                }else{
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.reloadData()
                    self.dataDescription = category[0].description
                    let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                    self.txtDescription.attributedText = attrStr
                    self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                    self.txtDescription.textColor = .white
                    if self.dataDescription.count > 164{
                        self.btnSeeMore.isHidden = false
                    }else{
                        self.btnSeeMore.isHidden = true
                    }
                }
            }
        }
    }
    func getdataFavourites() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.FavouritesVideoPage { category, message ,bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalist = category
                if category.count == 0{
                    ToastView.shared.short(self.view, txt_msg: "No video")
                }else{
                    self.image = category[0].image
                    self.counter = 0
                    self.url = category[0].video
                    Shared.shared.video_id = category[0].id
                    self.video()
                    self.imgVideos.sd_setImage(with: URL(string: self.image), completed: nil)
                    self.tableView.reloadData()
                    self.dataDescription = category[0].description
                    let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
                    self.txtDescription.attributedText = attrStr
                    self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
                    self.txtDescription.textColor = .white
                    if self.dataDescription.count > 164{
                        self.btnSeeMore.isHidden = false
                    }else{
                        self.btnSeeMore.isHidden = true
                    }
                }
            }
        }
    }
    func video(){
            let url1 = URL(string: url)
            player = AVPlayer(url: url1!)
            avpController.player = player
            avpController.player?.play()
            avpController.player?.isMuted = false
            avpController.player?.volume = 0.8
            avpController.view.frame.size.height = VideoView.frame.size.height
            avpController.view.frame.size.width = VideoView.frame.size.width
            self.VideoView.addSubview(avpController.view)
            player?.actionAtItemEnd = .none
        if self.counter <= 3{
            NotificationCenter.default.addObserver(self,selector:#selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player?.currentItem)
        }
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        self.counter += 1
        video()
    }
    
    func setFavourites(){
        let parameter = ["video_id" : Shared.shared.video_id] as [String : Any]
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.SetFavouritesVideoPage(param: parameter) { message, bool in
            Spinner.instance.removeSpinner()
            if bool{
                ToastView.shared.short(self.view, txt_msg: message)
                self.onAddRemoveFavourite?(!self.isAddedToFav)
            }else{
                self.onAddRemoveFavourite?(false)
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func setWorkout(){
        let parameter = ["video_id" : Shared.shared.video_id] as [String : Any]
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.SetWorkoutVideoPage(param: parameter) { message, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.onAddRemoveTodayWorkout?(!self.isAddedToTodayWorkout)
                ToastView.shared.short(self.view, txt_msg: message)
            }else{
                self.onAddRemoveTodayWorkout?(false)
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }

    @IBAction func btnAddToFavourites(_ sender: Any) {
        setFavourites()
    }
    @IBAction func btnAddToTodayWorkout(_ sender: Any) {
        setWorkout()
    }
    @IBAction func btnAddToLog(_ sender: Any) {
        guard let nextVc = AddToLogsVc.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
    @IBAction func btnSeeMore(_ sender: Any) {
        Alert(Title: "Description", Message: self.dataDescription)
    }
    
    
    func Alert (Title: String,Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }


}

extension DetailsCellVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Details2Cell", for: indexPath) as? Details2Cell
        cell?.detileTiltle.text = datalist[indexPath.row].title
        cell?.detailimage.sd_setImage(with: URL(string: datalist[indexPath.row].image), placeholderImage:UIImage(named: ""))
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        avpController.player?.pause()
        self.url = datalist[indexPath.row].video
        Shared.shared.video_id = datalist[indexPath.row].id
        self.counter = 0
        self.video()
        lblTitle.text = datalist[indexPath.row].title
        self.dataDescription = datalist[indexPath.row].description
        let attrStr = try! NSAttributedString(data: self.dataDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
        self.txtDescription.attributedText = attrStr
        self.txtDescription.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
        self.txtDescription.textColor = .white
        if self.dataDescription.count > 164{
            self.btnSeeMore.isHidden = false
        }else{
            self.btnSeeMore.isHidden = true
        }

    }
    
}

