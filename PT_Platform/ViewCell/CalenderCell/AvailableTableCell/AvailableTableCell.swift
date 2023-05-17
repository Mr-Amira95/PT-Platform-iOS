//
//  AvailableTableCell.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 29/08/2022.
//

import UIKit

class AvailableTableCell: UITableViewCell {
    
    var dataList : [AvailableM] = []
    var Vc : CalenderVC?
    var selectedIndex = 0
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    {
    didSet{
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AvailableCell", bundle: nil), forCellWithReuseIdentifier: "AvailableCell")
        self.collectionView.reloadData()
    }
}

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year,.month,.day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        Shared.shared.datTo = "\(dateTimeComponents.day ?? 0)"
        Shared.shared.monthto = "\(dateTimeComponents.year ?? 0)-\(dateTimeComponents.month ?? 0)"
        getAvailable()
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadGetAvailable), name: NSNotification.Name(rawValue: "ReloadGetAvailable"), object: nil)
    }
    

    
    @objc func ReloadGetAvailable() {
        getAvailable()
    }
    
    func getAvailable(){
        ControllerService.instance.coachCalendarPage { Available, message, bool in
            if bool{
                if Available.count != 0{
//                    if Available[0].is_available as? Bool ?? false == true{
                        Shared.shared.calendarTimeId = Available[0].id as? Int ?? 0
                        Shared.shared.calendarTimeValue = Available[0].time as? String ?? ""
                        self.dataList = Available
                        self.collectionView.reloadData()
//                    }
                }else{
                    self.dataList = []
                    self.collectionView.reloadData()
                    self.Alert(Message: "There are no available appointments on \(Shared.shared.monthto)-\(Shared.shared.datTo)")
                }
            }
        }
    }
    func Alert (Message: String){
        let alert = UIAlertController(title: "Ooops!", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.Vc?.present(alert, animated: true, completion: nil)
    }
}
extension AvailableTableCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableCell", for: indexPath) as? AvailableCell
        cell?.lblTime.text = dataList[indexPath.row].time as? String ?? ""
        if dataList[indexPath.row].is_available as? Bool ?? false == false{
            cell?.lblTime.backgroundColor = UIColor.red
            cell?.lblTime.layer.cornerRadius = 20
            cell?.lblTime.layer.masksToBounds = true
        }else{
            if selectedIndex == indexPath.item{
                cell?.lblTime.backgroundColor = UIColor(red:141/255, green:198/255, blue:62/255, alpha: 1)
                cell?.lblTime.layer.cornerRadius = 20
                cell?.lblTime.layer.masksToBounds = true
            }else{
                cell?.lblTime.backgroundColor = .none
            }
        }
            return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataList[indexPath.row].is_available as? Bool ?? false == true{
            self.selectedIndex = indexPath.item
            self.collectionView.reloadData()
            Shared.shared.calendarTimeId = dataList[indexPath.row].id as? Int ?? 0
            Shared.shared.calendarTimeValue = dataList[indexPath.row].time as? String ?? ""
        }
    }

    
}
