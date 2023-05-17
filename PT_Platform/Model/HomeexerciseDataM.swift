//
//  HomeDataM.swift
//  PT_Platform
//
//  Created by mustafakhallad on 22/05/2022.
//

import Foundation
import SwiftyJSON


class HomeexerciseDataM{
    var id : Int
    var title : String
    init(id:Int,title:String){
        self.id = id
        self.title = title
    }
}


class CategoryM:NSObject {
    var id : Any
    var title : Any
    var exercisesArray = [ExercisesInM]()
    
    
    
    init?(dict: Dictionary<String, JSON>)
    {
        let id = dict["id"]?.string
        let title = dict["title"]?.string
        let exercises = dict["exercises"]?.array

        self.id = id as Any
        self.title = title
        var Datalist : [ExercisesM] = []
        for item in exercises! {
            if let data = item.dictionary, let categoryData = ExercisesM.init(dict: data)
            {
                    let title = data["title"]?.string
                    let description = data["description"]?.string
                    let icon = data["icon"]?.string
                    let id = data["id"]?.int
                    print(title)
                    let obj = ExercisesInM(idIn: id ?? 0, id: categoryData.id as! Int ?? 0, title: title ?? "", description: description ?? "", icon: icon ?? "")
                    self.exercisesArray.append(obj)
            }
        }
    }
}


class ExercisesM {
    var id : Any

    
    init?(dict: Dictionary<String, JSON>)
    {
        let id = dict["id"]?.int

        self.id = id
    }

    
}

class ExercisesInM {
    var title : Any
    var description : Any
    var icon : Any
    var idIn : Any
    var id : Any
    
    init(idIn:Int,id:Int,title:String,description:String,icon:String){
        self.idIn = idIn
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        
    }
    
}
