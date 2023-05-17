//
//  ChallengesVideoM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 10/08/2022.
//

import Foundation

class ChallengesVideoM{
    
    var id : Int
    var idIn : Int
    var is_complete : Bool
    var title : String
    var description : String
    var image : String
    var video : String
    var is_favourite : Bool
    var is_today_log : Bool
    var is_workout : Bool
    var is_select = "no"
    
    
    init(id:Int,idIn:Int,is_complete:Bool,title:String,description:String,image:String,video:String,is_favourite:Bool,is_today_log:Bool,is_workout:Bool){
        
        self.id = id
        self.idIn = idIn
        self.is_complete = is_complete
        self.title = title
        self.description = description
        self.image = image
        self.video = video
        self.is_favourite = is_favourite
        self.is_today_log = is_today_log
        self.is_workout = is_workout
        
        
    }
    
}
