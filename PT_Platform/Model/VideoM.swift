//
//  VideoM.swift
//  PT_Platform
//
//  Created by mustafakhallad on 22/05/2022.
//

import Foundation
class VideoM{
    var id : Int
    var title : String
    var description : String
    var image : String
    var video : String
    var is_favourite : Int
    var is_today_log : Int
    var is_workout : Int
    
    init(id:Int,title:String,description:String,image:String,video:String,is_favourite:Int,is_today_log:Int,is_workout:Int){
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.video = video
        self.is_favourite = is_favourite
        self.is_today_log = is_today_log
        self.is_workout = is_workout
        
        
    }
}


