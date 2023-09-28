//
//  UIStoryboardEx.swift
//  PT_Platform
//
//  Created by mohammad lutfi on 18/09/2023.
//

import Foundation
import UIKit

enum Storyboard : String {
    case main = "Main"
    
}
extension UIStoryboard{
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
}

