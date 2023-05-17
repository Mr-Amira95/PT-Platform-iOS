//
//  ChallengesM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 09/08/2022.
//

import Foundation

class ChallengesM{
    
    var id : Int
    var idIn : Int
    var title : String
    var description : String
    var icon : String
    
    init(id:Int,idIn:Int,title:String,description:String,icon:String){
        
        self.id = id
        self.idIn = idIn
        self.title = title
        self.description = description
        self.icon = icon
    }
    
}
