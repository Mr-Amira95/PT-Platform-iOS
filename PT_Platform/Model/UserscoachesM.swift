//
//  UserscoachesM.swift
//  PT_Platform
//
//  Created by mustafakhallad on 23/05/2022.
//

import Foundation
class UserscoachesM{
    var id : Int
    var first_name : String
    var last_name : String
    var avatar : String
    var logo : String
    var is_subscription : Bool
    
    
    init(id:Int,first_name:String,last_name:String,avatar:String,logo:String,is_subscription:Bool){
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.avatar = avatar
        self.logo = logo
        self.is_subscription = is_subscription
    }
}
