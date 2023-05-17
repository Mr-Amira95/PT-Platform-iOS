//
//  WorkoutHistoryVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 31/05/2022.
//

import UIKit
import LanguageManager_iOS

class WorkoutHistoryVC: UIViewController {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCell")
        }
    }
    
    var datalist : [VideoM] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        btnCalender.setTitle("\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)-\(dateTimeComponents.day ?? 0)", for: .normal)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        self.navigationController?.navigationBar.isHidden = true
        
        getWorkoutHistory()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWorkoutHistory), name: NSNotification.Name(rawValue: "reloadDataWorkoutHistory"), object: nil)
    }
    
    @objc func reloadDataWorkoutHistory() {
        btnCalender.setTitle("\(Shared.shared.monthto)-\(Shared.shared.datTo)", for: .normal)
        getWorkoutHistory()
        }
    
    func getWorkoutHistory() {
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.workoutHistoryApi { history, bool in
            Spinner.instance.removeSpinner()
            if bool{
                if history.count == 0{
                    self.datalist = []
                    ToastView.shared.short(self.view, txt_msg: "There are no videos to show")
                }else{
                    self.datalist = history
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCalender(_ sender: Any) {
        Shared.shared.calendarEnterScreen = "WorkoutHistoryVC"
        guard let nextVc = CalenderPopupVC.storyboardInstance() else {return}
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }
    
}

extension WorkoutHistoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
        cell?.img.sd_setImage(with: URL(string: datalist[indexPath.row].image), placeholderImage:UIImage(named: "Trainer"))
        cell?.lbl.text = datalist[indexPath.row].title
            return cell!
    }

}
