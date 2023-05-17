//
//  RecipesM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 28/05/2022.
//

import Foundation
class RecipesM{
    var id : Any
    var image : Any
    var title : Any
    var description :Any
    var name : Any
    var time :Any
    var ingredient :Any
    
    
    
    
    init(id:Int,image:String,title:String,description:String,name:String,time:Int,ingredient:String){
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.name = name
        self.time = time
        self.ingredient = ingredient
        
    }
}

