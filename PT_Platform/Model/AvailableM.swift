//
//  AvailableM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 29/08/2022.
//

import Foundation

class AvailableM{
    var id : Any
    var time : Any
    var is_auto_accept : Any
    var is_available : Any
    
    init(id:Int,time:String,is_auto_accept:Bool,is_available:Bool){
        self.id = id
        self.time = time
        self.is_auto_accept = is_auto_accept
        self.is_available = is_available
        
    }
}
