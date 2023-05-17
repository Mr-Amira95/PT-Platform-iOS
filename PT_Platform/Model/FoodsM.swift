//
//  FoodsM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 01/06/2022.
//

import Foundation
class FoodsM{
    var id : Int
    var sku : String
    var calorie : Double
    var carb : Double
    var fat : Double
    var protein : Double
    var name : String
    var title : String
    
    
    init(id:Int,sku:String,calorie:Double,carb:Double,fat:Double,protein:Double,name:String,title:String){
        self.id = id
        self.sku = sku
        self.calorie = calorie
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.name = name
        self.title = title
        
        
    }
}
