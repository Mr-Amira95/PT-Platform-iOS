//
//  exercisesHistoryDetailsM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 19/11/2022.
//

import Foundation
class exercisesHistoryDetailsM{
    var id : Any
    var created_at : Any
    var weight_unit : Any
    var number : Any
    var weight : Any
    var repetition : Any
    var note : Any
    
    
    init(id:Int,created_at:String,weight_unit:String,number:Int,weight:Int,repetition:Int,note:String){
        self.id = id
        self.created_at = created_at
        self.weight_unit = weight_unit
        self.number = number
        self.weight = weight
        self.repetition = repetition
        self.note = note
    }
}

