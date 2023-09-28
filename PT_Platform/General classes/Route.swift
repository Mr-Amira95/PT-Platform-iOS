//
//  Route.swift
//  PT_Platform
//
//  Created by mohammad lutfi on 18/09/2023.
//

import Foundation
import UIKit

class Route: NSObject {
    
    static let Delegte = UIApplication.shared.delegate as! AppDelegate

    //MARK:- set viewControler is Root application two Way :-
    static func goHome(_ animated:Bool = true) {
        let tabbar = UIStoryboard.loadFromMain("ManTabBar")
        Delegte.switchRootVC(rootViewController: tabbar, animated: animated, completion: nil)
    }

    static func goCoachVC(_ animated:Bool = true) {
        let screen:ChooswTrainerVC = UIStoryboard.loadFromMain("ChooswTrainerVC") as! ChooswTrainerVC
        let nav = UINavigationController(rootViewController: screen)
        Delegte.switchRootVC(rootViewController: nav, animated: animated, completion: nil)
    }
}
