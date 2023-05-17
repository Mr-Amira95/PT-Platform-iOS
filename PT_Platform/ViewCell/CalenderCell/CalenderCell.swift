//
//  CalenderCell.swift
//  PT_Platform
//
//  Created by mustafa khallad on 28/08/2022.
//

import UIKit
import LanguageManager_iOS

class CalenderCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthframe: UIView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var index = 0
    var selectedIndex = Int ()
    
    var currentDay = 0
    var currentMonth = 0
    var currentYear = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        if LanguageManager.shared.currentLanguage == .en{
            btnPrevious.setImage(UIImage(named: "iconPrevious"), for: .normal)
            btnNext.setImage(UIImage(named: "iconNext"), for: .normal)
        }else{
            btnPrevious.setImage(UIImage(named: "iconNext"), for: .normal)
            btnNext.setImage(UIImage(named: "iconPrevious"), for: .normal)
        }
        setCellsView()
        setMonthView()
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
        let today = Date()
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
        currentDay = Int(calendarDate.day!)
        currentMonth = Int(calendarDate.month!)
        currentYear = Int(calendarDate.month!)
        
        
        totalSquares.removeAll()
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpacec = CalendarHelper().weekDay(date: firstDayOfMonth)
        var count: Int = 1
        while(count <= 42){
            if (count <= startingSpacec || count - startingSpacec > daysInMonth){
                totalSquares.append("")
            }else{
                if currentMonth >= Int(CalendarHelper().monthString(date: selectedDate))!{
                    if currentDay <= (count - startingSpacec){
                        totalSquares.append(String(count - startingSpacec))
                        selectedIndex = currentDay
                    }else{
                        totalSquares.append(" ")
                    }
                }else{
                    selectedIndex = 1
                    totalSquares.append(String(count - startingSpacec))
                }
            }
            count += 1
        }
        monthLabel.text = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthString(date: selectedDate)
        Shared.shared.monthto = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthString(date: selectedDate)
        
        if currentYear < Int(CalendarHelper().yearString(date: selectedDate))!{
            if currentMonth >= Int(CalendarHelper().monthString(date: selectedDate))!{
                btnPrevious.isHidden = true
            }else{
                btnPrevious.isHidden = false
            }
        }
        
        collectionView.reloadData()
        Shared.shared.datTo = "\(selectedIndex)"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadGetAvailable"), object: nil)
    }


    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().MinusMonth(date: selectedDate)
        setMonthView()
    }
    
    
    @IBAction func NextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
}



extension CalenderCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell2", for: indexPath) as? CalendarCell2
        cell?.datOfMonth.text = totalSquares[indexPath.item]
        if selectedIndex == indexPath.item + 1{

                cell?.datOfMonth.textColor = .red
        }else{
            cell?.datOfMonth.textColor = .white
        }
            return cell!
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item + 1
        self.collectionView.reloadData()
        Shared.shared.datTo = totalSquares[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadGetAvailable"), object: nil)
    }
    
}
