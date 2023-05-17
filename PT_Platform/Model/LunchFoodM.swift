//
//  LunchFoodM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 05/10/2022.
//

import Foundation
class LunchFoodM{
    var id : Any
    var sku : Any
    var name : Any
    var title : Any
    var calorie : Any
    var carb : Any
    var fat : Any
    var protein : Any
    var user_food_id : Any
    
    init(id:Int,sku:String,name:String,title:String,calorie:Double,carb:Double,fat:Double,protein:Double,user_food_id:Int){
        
        self.id = id
        self.sku = sku
        self.name = name
        self.title = title
        self.calorie = calorie
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.user_food_id = user_food_id
    }
}
