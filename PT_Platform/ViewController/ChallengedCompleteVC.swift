//
//  ChallengedCompleteVC.swift
//  PT_Platform
//
//  Created by QTechnetworks on 06/02/2022.
//

import UIKit

class ChallengedCompleteVC: UIViewController {
    
    var datalist = [ChallengesVideoM]()
    var ArrayVideo = [Int]()
    var NoIsComplete = 0
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChallengedComplete: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        }
    }
    @IBOutlet weak var btnFinish: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = Shared.shared.btnBack
        getChallengesVideodata()
    }
    
    func getChallengesVideodata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.ChallengesVideoApi { Fav, message, bool, bool1  in
            Spinner.instance.removeSpinner()
            if bool{
                if bool1{
                    self.datalist = Fav
                    for i in self.datalist{
                        if i.is_complete == true{
                            self.NoIsComplete += 1
                        }
                    }
                    if Shared.shared.getusertype() == "Coach"{
                        self.lblChallengedComplete.isHidden = true
                        self.btnFinish.isHidden = true
                    }
                    self.lblChallengedComplete.text = "\(self.NoIsComplete) - \(self.datalist.count) Challenged Complete"
                    if self.datalist.count == 0 || self.datalist.count == self.NoIsComplete {
                        self.btnFinish.isEnabled = false
                    }else{
                        self.btnFinish.isEnabled = true
                    }
                    self.collectionView.reloadData()
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFinish(_ sender: Any) {
        if ArrayVideo.count == 0{
            ToastView.shared.short(self.view, txt_msg: "Please, select a video")
        }else{
            let parameter = ["challenge_video_ids":ArrayVideo,
                             "coach_id":Shared.shared.getCoachId() ?? 0] as [String:Any]
//                Spinner.instance.showSpinner(onView: view)
            ControllerService.instance.postComplete (param: parameter) { message, bool, bool2 in
//                Spinner.instance.removeSpinner()
                if bool{
                    if bool2{
                        ToastView.shared.short(self.view, txt_msg: message)
                        self.getChallengesVideodata()
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
    }

    
}
 
extension ChallengedCompleteVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        cell?.SetData(data: datalist[indexPath.row])
        let video = datalist[indexPath.row]
        cell?.btnCheck.isHidden = false
        if video.is_complete == true{
            cell?.btnCheck.isEnabled = false
            cell?.btnCheck.setImage(UIImage(named: "CheckboxIcon"), for: .normal)
        }else{
            cell?.btnCheck.isEnabled = true
            if video.is_select == "yes"{
                cell?.btnCheck.setImage(UIImage(named: "CheckboxIcon"), for: .normal)
            }else{
                cell?.btnCheck.setImage(UIImage(named: "UnCheckboxIcon"), for: .normal)
            }
        }
        if Shared.shared.getusertype() == "Coach"{
            cell?.btnCheck.isEnabled = false
        }
        cell?.btnCheck.tag = indexPath.row
        cell?.btnCheck.addTarget(self, action: #selector(checkId(_:)), for: .touchUpInside)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = datalist[indexPath.row]
        Shared.shared.exercise_id = video.id as? Int ?? 0
        Shared.shared.exercise_name = video.title as? String ?? ""
        Shared.shared.exercise_description = video.description as? String ?? ""
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavDetailsCellVC")
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
    @objc func checkId(_ sender:UIButton){
        let video = datalist[sender.tag]
        let ArrayVideoId = [video.id as? Int ?? 0]
            if video.is_select == "no"{
                video.is_select = "yes"
                ArrayVideo.append(contentsOf: ArrayVideoId)
                }else{
                    var id = 0
                    for item in ArrayVideo {
                        if item == video.id as? Int ?? 0{
                            ArrayVideo.remove(at: id)
                            video.is_select = "no"
                        }
                        id += 1
                    }

                }
        self.collectionView.reloadData()
    }
    
    
}
