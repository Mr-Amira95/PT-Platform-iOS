//
//  HomePageCoachVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 25/01/2022.
//

import UIKit
import ImageSlideshow
import LanguageManager_iOS


struct Model3 {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
}

class HomePageCoachVC: UIViewController {
    
    var models3 = [Model3]()
    var datalist = [BannersM]()
    var impArray = [SDWebImageSource]()
    var datalistCoaches = [UserscoachesM]()
    
    
    
    
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var viewInfoUser: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtNameUser: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HomePageCoachCell", bundle: nil), forCellWithReuseIdentifier: "HomePageCoachCell")
        }
    }
    @IBOutlet weak var collectionViewCoach: UICollectionView!
    {
        didSet{
            self.collectionViewCoach.delegate = self
            self.collectionViewCoach.dataSource = self
            collectionViewCoach.register(UINib(nibName: "HomePageCoachCell", bundle: nil), forCellWithReuseIdentifier: "HomePageCoachCell")
        }
    }
    
    
    @IBOutlet weak var sliderView: ImageSlideshow!{
        didSet{
            sliderView.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            sliderView.addGestureRecognizer(gestureRecognizer)
            sliderView.contentMode = .scaleToFill
            sliderView.contentScaleMode = .scaleToFill
            sliderView.clipsToBounds = true
            sliderView.slideshowInterval = 4
            
        }
    }
    
    
    
//        PickerView
    fileprivate var CoachesPicker = UIPickerView() {
        didSet{
            CoachesPicker.delegate = self
            CoachesPicker.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        Shared.shared.bannerIn = "second"
        if Shared.shared.getusertype() == "Coach"{
            scrollViewMain.isHidden = true
            addData31()
            self.getdataBaneer()
        }else{
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(named: "MainColor")
            toolBar.sizeToFit()

            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(reloadHomePageCoachVC))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolBar.setItems([spaceButton,doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            txtNameUser.inputAccessoryView = toolBar
            
            collectionViewCoach.isHidden = true
            addData3()
            txtNameUser.inputView = CoachesPicker
            CoachesPicker.delegate = self
            CoachesPicker.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomePageCoachVC), name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataNotification), name: NSNotification.Name(rawValue: "reloadDataNotification"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Shared.shared.getusertype() != "Coach"{
            getAssignedCoach()
        }
    }
    
    @objc func reloadHomePageCoachVC() {
        txtNameUser.text = Shared.shared.getCoachName()
        let image = UIImage(named: "DownIcon")!
        addLeftImageTo(txtField: txtNameUser, andImage: image)
        self.imgUser.sd_setImage(with: URL(string: Shared.shared.getCoachImage() ?? ""), placeholderImage:UIImage(named: "CoachDefaultIcon"))
        Shared.shared.bannerIn = "second"
        self.getdataBaneer()
        self.view.endEditing(true)
    }
    
    @objc func reloadDataNotification() {
        if Shared.shared.notificationType == "new_coach"{
            getDataCoachForNotification()
        }else if Shared.shared.notificationType == "news_feed"{
            Shared.shared.btnBack = "News"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "News2VC") as! News2VC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.notificationType == "expired_package"{
            Shared.shared.btnBack = "Shop"
            let storyboard = UIStoryboard(name: "Packages", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.notificationType == "calender" || Shared.shared.notificationType == "approved_video_chat"{
            Shared.shared.btnBack = "Calendar"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CalenderCoachVC") as! CalenderCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.notificationType == "personal_training"{
            Shared.shared.btnBack = "Personal Training"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalTrainingCoachVC") as! PersonalTrainingCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.notificationType == "message"{
            Shared.shared.btnBack = "Live Chat"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    
    func getDataCoachForNotification(){
        ControllerService.instance.userscoachesSorNotification { id, first_name, last_name, avatar, logo, bool in
            if bool{
                self.txtNameUser.text = last_name
                Shared.shared.saveCoachName(auth: last_name)
                Shared.shared.saveCoachImage(auth: logo)
                Shared.shared.saveCoachId(auth: id)
            }
        }
    }
    
    func getdata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.userscoaches { category, bool in
            if bool{
                Spinner.instance.removeSpinner()
                self.datalistCoaches = category
                Shared.shared.coachMArray = category as NSArray
                if Shared.shared.getCoachId() == 0 || Shared.shared.getCoachId() == nil{
                    self.txtNameUser.text = "\(self.datalistCoaches[0].last_name)"
                    Shared.shared.saveCoachName(auth: "\(self.datalistCoaches[0].last_name)")
                    Shared.shared.saveCoachImage(auth: self.datalistCoaches[0].logo)
                    Shared.shared.saveCoachId(auth: self.datalistCoaches[0].id)
                    Shared.shared.bannerIn = "second"
                    self.getdataBaneer()
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
                }
            }
        }
    }
    
    func getAssignedCoach(){
        let parameter = ["skip" : "0",
                         "filter" : "assigned_coaches"]
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.assignedcoaches(param: parameter) { assigned, message, bool1, bool2  in
            Spinner.instance.removeSpinner()
            if bool1{
                if bool2{
                    self.datalistCoaches = assigned
                    Shared.shared.coachMArray = assigned as NSArray
                    if Shared.shared.getCoachId() == 0 || Shared.shared.getCoachId() == nil{
                        self.txtNameUser.text = "\(self.datalistCoaches[0].last_name)"
                        Shared.shared.saveCoachName(auth: "\(self.datalistCoaches[0].last_name)")
                        Shared.shared.saveCoachImage(auth: self.datalistCoaches[0].logo)
                        Shared.shared.saveCoachId(auth: self.datalistCoaches[0].id)
                        Shared.shared.bannerIn = "second"
                        self.getdataBaneer()
                    }else{
                        var count = 0
                        for i in assigned{
                            count += 1
                            if i.id == Shared.shared.getCoachId(){
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePageCoachVC"), object: nil)
                                break
                            }else{
                                if assigned.count == count{
                                    self.txtNameUser.text = "\(self.datalistCoaches[0].last_name)"
                                    Shared.shared.saveCoachName(auth: "\(self.datalistCoaches[0].last_name)")
                                    Shared.shared.saveCoachImage(auth: self.datalistCoaches[0].logo)
                                    Shared.shared.saveCoachId(auth: self.datalistCoaches[0].id)
                                    Shared.shared.bannerIn = "second"
                                    self.getdataBaneer()
                                }
                            }
                        }
                    }
                }else{
                    ToastView.shared.short(self.view, txt_msg: "No assigned coaches to show")
                }
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    

    
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImage.image = img
        txtField.rightView = leftImage
        txtField.rightViewMode = .always
    }
    
    func getData(){
        impArray.removeAll()
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
        if datalist.count != 0{
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
    
    func addData3() {
        if LanguageManager.shared.currentLanguage == .en{
            models3.append(Model3(text: "Exercises", imageName: "Icon1"))
            models3.append(Model3(text: "Workouts", imageName: "Icon2"))
            models3.append(Model3(text: "Kyc", imageName: "Kyc"))
            models3.append(Model3(text: "Personal Training", imageName: "Icon5"))
            models3.append(Model3(text: "Challenges", imageName: "Icon6"))
            models3.append(Model3(text: "History", imageName: "History"))
            models3.append(Model3(text: "Favorites", imageName: "Favorites"))
            models3.append(Model3(text: "Calendar", imageName: "Calendar"))
            models3.append(Model3(text: "Today’s Workout", imageName: "TodayWorkout"))
            models3.append(Model3(text: "Shop", imageName: "Shop"))
            models3.append(Model3(text: "Video Chat", imageName: "VideoChat"))
            models3.append(Model3(text: "Live Chat", imageName: "LiveChat"))
        }else{
            models3.append(Model3(text: "تمارين", imageName: "Icon1"))
            models3.append(Model3(text: "مجموعات", imageName: "Icon2"))
            models3.append(Model3(text: "معلومات عن العميل", imageName: "Kyc"))
            models3.append(Model3(text: "تمرين شخصي", imageName: "Icon5"))
            models3.append(Model3(text: "تحديات", imageName: "Icon6"))
            models3.append(Model3(text: "السجل", imageName: "History"))
            models3.append(Model3(text: "المفضلة", imageName: "Favorites"))
            models3.append(Model3(text: "التقويم", imageName: "Calendar"))
            models3.append(Model3(text: "تمارين اليوم", imageName: "TodayWorkout"))
            models3.append(Model3(text: "المتجر", imageName: "Shop"))
            models3.append(Model3(text: "محادثة فيديو", imageName: "VideoChat"))
            models3.append(Model3(text: "محادثة مباشرة", imageName: "LiveChat"))
        }

    }
    
    func addData31() {
        if LanguageManager.shared.currentLanguage == .en{
            models3.append(Model3(text: "Exercises", imageName: "Icon1"))
            models3.append(Model3(text: "Workouts", imageName: "Icon2"))
            models3.append(Model3(text: "Challenges", imageName: "Icon6"))
            models3.append(Model3(text: "Personal Training", imageName: "Icon5"))
            models3.append(Model3(text: "Calendar", imageName: "Calendar"))
            models3.append(Model3(text: "Video Chat", imageName: "VideoChat"))
            models3.append(Model3(text: "Live Chat", imageName: "LiveChat"))
            models3.append(Model3(text: "Kyc", imageName: "Kyc"))
            models3.append(Model3(text: "User's History", imageName: "History"))
            models3.append(Model3(text: "Progress", imageName: "Icon4-1"))
            models3.append(Model3(text: "Language", imageName: "IconLanguage"))
            models3.append(Model3(text: "Delete My Account", imageName: "IconDeleteAccount"))
            models3.append(Model3(text: "Logout", imageName: "IconLogout"))
        }else{
            models3.append(Model3(text: "تمارين", imageName: "Icon1"))
            models3.append(Model3(text: "مجموعات", imageName: "Icon2"))
            models3.append(Model3(text: "تحديات", imageName: "Icon6"))
            models3.append(Model3(text: "تمرين شخصي", imageName: "Icon5"))
            models3.append(Model3(text: "التقويم", imageName: "Calendar"))
            models3.append(Model3(text: "محادثة فيديو", imageName: "VideoChat"))
            models3.append(Model3(text: "محادثة مباشرة", imageName: "LiveChat"))
            models3.append(Model3(text: "معلومات عن العميل", imageName: "Kyc"))
            models3.append(Model3(text: "سجل المستخدم", imageName: "History"))
            models3.append(Model3(text: "التطور", imageName: "Icon4-1"))
            models3.append(Model3(text: "اللغة", imageName: "IconLanguage"))
            models3.append(Model3(text: "احذف حسابي", imageName: "IconDeleteAccount"))
            models3.append(Model3(text: "تسجيل الخروج", imageName: "IconLogout"))
        }
    }


}

extension HomePageCoachVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models3.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCoachCell", for: indexPath) as? HomePageCoachCell
        cell?.SetData(data: models3[indexPath.row])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Shared.shared.btnBack = models3[indexPath.row].text
        if models3[indexPath.row].text == "Exercises" || models3[indexPath.row].text == "تمارين" || models3[indexPath.row].text == "Workouts" || models3[indexPath.row].text == "مجموعات"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExercisesVC") as! ExercisesVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Favorites" || models3[indexPath.row].text == "Today’s Workout" || models3[indexPath.row].text == "المفضلة" || models3[indexPath.row].text == "تمارين اليوم"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Live Chat" || models3[indexPath.row].text == "محادثة مباشرة"{
            if Shared.shared.getusertype() == "Coach"{
                Shared.shared.enterListUser = "Live Chat"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
                let navigationController = UINavigationController(rootViewController: controller)
                self.present(navigationController, animated: true, completion: nil)
            }
        }else if models3[indexPath.row].text == "Video Chat" || models3[indexPath.row].text == "محادثة فيديو"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "VideoChatCoachVC") as! VideoChatCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Personal Training" || models3[indexPath.row].text == "تمرين شخصي"{
            if Shared.shared.getusertype() == "Coach"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PersonalTrainingCoachVC") as! PersonalTrainingCoachVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PersonalTrainingVideoVC") as! PersonalTrainingVideoVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else if models3[indexPath.row].text == "Shop" || models3[indexPath.row].text == "المتجر"{
            let storyboard = UIStoryboard(name: "Packages", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Challenges" || models3[indexPath.row].text == "تحديات"{
            if Shared.shared.getusertype() == "Coach"{
                Shared.shared.enterListUser = "Challenges"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ChallengesVC") as! ChallengesVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else if models3[indexPath.row].text == "History" || models3[indexPath.row].text == "السجل"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HistoryListVC") as! HistoryListVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "User's History" || models3[indexPath.row].text == "سجل المستخدم"{
            Shared.shared.enterListUser = "History"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Kyc" || models3[indexPath.row].text == "معلومات عن العميل"{
            if Shared.shared.getusertype() == "Coach"{
                Shared.shared.enterListUser = "Questions"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Questions", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "QuestionsVC") as! QuestionsVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else if models3[indexPath.row].text == "Calendar" || models3[indexPath.row].text == "التقويم"{
            if Shared.shared.getusertype() == "Coach"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "CalenderCoachVC") as! CalenderCoachVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else if models3[indexPath.row].text == "Logout" || models3[indexPath.row].text == "تسجيل الخروج"{
            Shared.shared.isLogin(auth: false)
            Shared.shared.saveid(auth: "")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TellUsVC")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }else if models3[indexPath.row].text == "Language" || models3[indexPath.row].text == "اللغة"{
            guard let nextVc = SelectLanguageVc.storyboardInstance() else {return}
            self.navigationController?.present(nextVc, animated: true, completion: nil)
        }else if models3[indexPath.row].text == "Progress" || models3[indexPath.row].text == "التطور"{
            Shared.shared.enterListUser = "Progress"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListOfUserInCoachVC") as! ListOfUserInCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if models3[indexPath.row].text == "Delete My Account" || models3[indexPath.row].text == "احذف حسابي"{
            deleteAccoutn()
            
        }
        
    }
    
    func deleteAccoutn(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the account?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Please, enter your password"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let parameter = ["password" : textField?.text ?? "",
                             "password_confirmation" : textField?.text ?? "",
                             "device_player_id" : Shared.shared.device_player_id ?? 0] as [String : Any]
            if textField?.text ?? "" == ""{
                self.Alert1(Message: "Please, enter your password")
            }else{
                ControllerService.instance.deleteMyAccountApi(param: parameter) { message, bool in
                    if bool{
                        Shared.shared.isLogin(auth: false)
                        Shared.shared.saveid(auth: "")
                        Shared.shared.saveCoachId(auth: 0)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TellUsVC")
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true, completion: nil)
                    }else{
                        self.Alert1(Message: message)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func Alert1(Message: String){
        let alert = UIAlertController(title: "Whoops", message:Message , preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        self.present(alert,animated: true,completion: nil)
    }
    
    
}


extension HomePageCoachVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return datalistCoaches.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(datalistCoaches[row].last_name)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            Shared.shared.saveCoachName(auth: "\(datalistCoaches[row].last_name)")
            Shared.shared.saveCoachImage(auth: datalistCoaches[row].logo)
            Shared.shared.saveCoachId(auth: datalistCoaches[row].id)
    }

}
