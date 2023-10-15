//
//  String.swift
//  PT_Platform
//
//  Created by mohammad lutfi on 11/09/2023.
//

import Foundation

extension String{
    var toInt:Int{
        return Int(self)!
    }
    var toDouble:Double{
        return Double(self)!
    }
    var toFloat:Float{
        return Float(self)!
    }
    func changeToEnglishNumber()->String{
        
        let NumberStr: String = self
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = Locale(identifier: "EN")
        let final = Formatter.number(from: NumberStr)
        return final?.stringValue ?? "0.0"
    }
}
