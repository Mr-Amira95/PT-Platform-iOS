//
//  CalenderCoachM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 25/09/2022.
//

import Foundation
class CalenderCoachM{
    var id : Any
    var date : Any
    var time : Any
    var status : Any
    var user_name : Any
    var is_auto_accept : Any
    
    init(id:Int,date:String,time:String,status:String,user_name:String,is_auto_accept:Bool){
        
        self.id = id
        self.date = date
        self.time = time
        self.status = status
        self.user_name = user_name
        self.is_auto_accept = is_auto_accept
    }
}
