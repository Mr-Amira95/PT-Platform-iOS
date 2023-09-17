//
//  PackegeSubscriptionM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 17/08/2022.
//

import Foundation

class PackegeSubscriptionM{
    
    var id : Int
    var name : String
    var description : String
    var price : String
    var style : String
    var date : String
    var is_free : Bool
    var is_shop : Bool
    var can_shop : Bool
    var permissionsCallVideo : String
    var permissionsWorkoutSchedule : Bool
    var permissionsFoodPlan : Bool
    var purchase_apple_id : String
    var startAndEndDate : String
    
    
    
    init(id:Int,name:String,description:String,price:String,style:String,date:String,is_free:Bool,is_shop:Bool,can_shop:Bool,permissionsCallVideo:String,permissionsWorkoutSchedule:Bool,permissionsFoodPlan:Bool,purchase_apple_id:String,startAndEndDate:String){
        
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.style = style
        self.date = date
        self.is_free = is_free
        self.is_shop = is_shop
        self.can_shop = can_shop
        self.permissionsCallVideo = permissionsCallVideo
        self.permissionsWorkoutSchedule = permissionsWorkoutSchedule
        self.permissionsFoodPlan = permissionsFoodPlan
        self.purchase_apple_id = purchase_apple_id
        self.startAndEndDate = startAndEndDate
    }
    
}
