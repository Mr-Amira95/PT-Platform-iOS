//
//  TrainingPersonalCoachM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 24/09/2022.
//

import Foundation
class TrainingPersonalCoachM{
    var id : Any
    var avatar : Any
    var name : Any
    var start_date : Any
    var end_date : Any
    var package_name : Any
    var type : Any
    
    init(id:Int,avatar:String,name:String,start_date:String,end_date:String,package_name:String,type:String){
        
        self.id = id
        self.avatar = avatar
        self.name = name
        self.start_date = start_date
        self.end_date = end_date
        self.package_name = package_name
        self.type = type
    }
}

