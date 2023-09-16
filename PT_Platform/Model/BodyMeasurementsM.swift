//
//  BodyMeasurementsM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 14/08/2022.
//

import Foundation

class BodyMeasurementsM{
    
    var date : String
    var neck : String
    var chest : String
    var left_arm : String
    var right_arm : String
    var waist : String
    var belly : String
    var lower_belly : String
    var upper_belly : String
    var hips : String
    var left_thigh : String
    var right_thigh : String
    var lift_calf : String
    var right_calf : String
    
    
    
    init(date:String,neck:String,chest:String,left_arm:String,right_arm:String,waist:String,belly:String,lower_belly:String,upper_belly:String,hips:String,left_thigh:String,right_thigh:String,lift_calf:String,right_calf:String){
        
        self.date = date
        self.neck = neck
        self.chest = chest
        self.left_arm = left_arm
        self.right_arm = right_arm
        self.waist = waist
        self.belly = belly
        self.lower_belly = lower_belly
        self.upper_belly = upper_belly
        self.hips = hips
        self.left_thigh = left_thigh
        self.right_thigh = right_thigh
        self.lift_calf = lift_calf
        self.right_calf = right_calf
        
        
    }
    
}
