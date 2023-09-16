//
//  exercisesHistoryDetailsM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 19/11/2022.
//

import Foundation
class exercisesHistoryDetailsM{
    var id : Int
    var created_at : String
    var weight_unit : String
    var number : String
    var weight : String
    var repetition : String
    var note : String
    
    
    init(id:Int,created_at:String,weight_unit:String,number:String,weight:String,repetition:String,note:String){
        self.id = id
        self.created_at = created_at
        self.weight_unit = weight_unit
        self.number = number
        self.weight = weight
        self.repetition = repetition
        self.note = note
    }
}

