//
//  BodyMeasurementsM.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 14/08/2022.
//

import Foundation

class BodyMeasurementsM{
    
    var date : String
    var neck : Double
    var chest : Double
    var left_arm : Double
    var right_arm : Double
    var waist : Double
    var belly : Double
    var lower_belly : Double
    var upper_belly : Double
    var hips : Double
    var left_thigh : Double
    var right_thigh : Double
    var lift_calf : Double
    var right_calf : Double
    
    
    
    init(date:String,neck:Double,chest:Double,left_arm:Double,right_arm:Double,waist:Double,belly:Double,lower_belly:Double,upper_belly:Double,hips:Double,left_thigh:Double,right_thigh:Double,lift_calf:Double,right_calf:Double){
        
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
