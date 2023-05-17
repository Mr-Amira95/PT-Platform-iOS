//
//  Spinner.swift
//  PT_Platform
//
//  Created by mustafakhallad on 20/05/2022.
//

import Foundation
import UIKit

var vSpinner : UIView?

class Spinner {
    static let instance = Spinner()
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .large)
        //ai.tintColor = UIColor.white
        ai.color = UIColor.green
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
