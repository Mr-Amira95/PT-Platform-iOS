//
//  CalendarHelper.swift
//  PT_Platform
//
//  Created by mustafa khallad on 28/08/2022.
//

import Foundation
import UIKit
class CalendarHelper{
    let calendar = Calendar.current
    
    func plusMonth(date:Date)->Date{
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func MinusMonth(date:Date)->Date{
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
    func yearString(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    func daysInMonth(date:Date)->Int{
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    func dayOfMonth(date:Date)->Int{
        let components = calendar.dateComponents([.day],from: date)
        return components.day!
        
    }
    func firstOfMonth(date:Date) -> Date{
        let components = calendar.dateComponents([.year,.month], from: date)
        return calendar.date(from: components)!
    }
    func weekDay(date:Date) -> Int{
        let components = calendar.dateComponents([.weekday],from: date)
        return components.weekday! - 1
    }
    
}
