//
//  RequestSentVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 10/11/2022.
//

import UIKit
import Foundation
import EventKit

class RequestSentVC: UIViewController {
    
    let eventStore : EKEventStore = EKEventStore()
    var created_at = ""
    var duration1 = ""
    var join_url = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnReturnToMainScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomePageCoachVC") as! HomePageCoachVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func BtnAddToCalendar(_ sender: Any) {
        setEvent()
    }
   
    
    
    func setEvent(){
        eventStore.requestAccess(to: .event) { (granted, error) in
          if (granted) && (error == nil) {
              let event:EKEvent = EKEvent(eventStore: self.eventStore)
              event.title = "Appointment with Coach \(Shared.shared.getCoachName() ?? "")"
              self.created_at = "\(Shared.shared.monthto)-\(Shared.shared.datTo) \(Shared.shared.calendarTimeValue)"
              let dateFormatterStatr = DateFormatter()
              dateFormatterStatr.dateFormat = "yyyy-MM-dd HH:mm:00"
              let dateStart = dateFormatterStatr.date(from:self.created_at)
              event.startDate = dateStart
              let dateFormatterEnd = DateFormatter()
              dateFormatterEnd.dateFormat = "yyyy-MM-dd HH:mm:00"
              let dateEnd = dateFormatterEnd.date(from:self.created_at)
              let date = dateEnd?.addingTimeInterval(TimeInterval(30.0 * 60.0))
              event.endDate = date
              event.notes = "Join to meeting \(self.join_url)"
              let alarm1hour = EKAlarm(relativeOffset: -3600) //1 hour
              event.addAlarm(alarm1hour)
              event.calendar = self.eventStore.defaultCalendarForNewEvents
              do {
                  try self.eventStore.save(event, span: .thisEvent)
                  DispatchQueue.main.async {
                      self.Alert(Title: "Successful", Message: "Saved to calendar")
                  }
              } catch let error as NSError {
                  DispatchQueue.main.async {
                      self.Alert(Title: "Failed", Message: "failed to save event with error : \(error)")
                  }
              }
          }else{
              DispatchQueue.main.async {
                  self.Alert(Title: "Failed", Message: "failed to save event with error : \(String(describing: error)) or access not granted")
              }
          }
        }
       
    }
    
    func Alert (Title: String,Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomePageCoachVC") as! HomePageCoachVC
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    

}
