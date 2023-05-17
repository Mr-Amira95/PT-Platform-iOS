//
//  VideoChatCoachM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 26/09/2022.
//

import Foundation
class VideoChatCoachM{
    var id : Any
    var userId : Any
    var nameUser : Any
    var startLink : Any
    var timeLink : Any
    var dateLink : Any
    var statusUser : Any
    
    init(id:Int,userId:Int,nameUser:String,startLink:String,timeLink:String,dateLink:String,statusUser:String){
        
        self.id = id
        self.userId = userId
        self.nameUser = nameUser
        self.startLink = startLink
        self.timeLink = timeLink
        self.dateLink = dateLink
        self.statusUser = statusUser
    }
}
