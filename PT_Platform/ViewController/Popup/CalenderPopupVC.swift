//
//  CalenderPopupVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 16/10/2022.
//

import UIKit
import LanguageManager_iOS

class CalenderPopupVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var index = 0
    var selectedIndex = Int ()
    
    static func storyboardInstance() -> CalenderPopupVC? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CalenderPopupVC") as? CalenderPopupVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            btnPrevious.setImage(UIImage(named: "iconPreviousWhite"), for: .normal)
            btnNext.setImage(UIImage(named: "iconNextWhite"), for: .normal)
        }else{
            btnPrevious.setImage(UIImage(named: "iconNextWhite"), for: .normal)
            btnNext.setImage(UIImage(named: "iconPreviousWhite"), for: .normal)
        }
        setCellsView()
        setMonthView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
    }
    
    func setCellsView(){
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.register(UINib(nibName: "CalendarCell2", bundle: nil), forCellWithReuseIdentifier: "CalendarCell2")
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
    }
    func setMonthView(){
        totalSquares.removeAll()
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpacec = CalendarHelper().weekDay(date: firstDayOfMonth)
        var count: Int = 1
        while(count <= 42){
            if (count <= startingSpacec || count - startingSpacec > daysInMonth){
                totalSquares.append("")
            }else{
                totalSquares.append(String(count - startingSpacec))
            }
            count += 1
        }
        monthLabel.text = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthString(date: selectedDate)
        Shared.shared.monthto = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthString(date: selectedDate)
        collectionView.reloadData()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().MinusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func NextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.dismiss(animated: true)
        if Shared.shared.calendarEnterScreen == "WorkoutHistoryVC"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataWorkoutHistory"), object: nil)
        }else if Shared.shared.calendarEnterScreen == "NutritionHistoryVC"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataNutritionHistory"), object: nil)
        }else if Shared.shared.calendarEnterScreen == "FoodVC"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataFood"), object: nil)
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension CalenderPopupVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell2", for: indexPath) as? CalendarCell2
        cell?.datOfMonth.text = totalSquares[indexPath.item]
        if selectedIndex == indexPath.item{
            if #available(iOS 15.0, *) {
                cell?.datOfMonth.textColor = .red
            } else {
                cell?.datOfMonth.textColor = .red
            }
        }else{
            cell?.datOfMonth.textColor = .white
        }
            return cell!
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        self.collectionView.reloadData()
        Shared.shared.datTo = totalSquares[indexPath.item]
        monthLabel.text = "\(Shared.shared.monthto)-\(Shared.shared.datTo)"
    }
    
}
