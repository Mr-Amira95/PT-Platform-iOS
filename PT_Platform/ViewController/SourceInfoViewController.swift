//
//  SourceInfoViewController.swift
//  PT_Platform
//
//  Created by User on 11/08/2023.
//

import UIKit

class SourceInfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }

    var type: SourceType = .supplements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = type.title
        descriptionText.text = type.sourceDescription
    }
    @IBAction func okayBtn(_ sender: Any) {
        dismiss(animated: false)
    }
}


enum SourceType {
    case supplements
    case recipesandDietPlans
    case food
    case caloricBalanceEquation
    case caloriesCalculator

    var title: String {
        switch self {
        case .supplements:
            return "Supplements"
        case .recipesandDietPlans:
            return "Recipes and Diet Plans"
        case .food:
            return "Food"
        case .caloricBalanceEquation:
            return "Caloric Balance Equation"
        case .caloriesCalculator:
            return "Calories Calculator"
        }
    }
    
    var sourceDescription: String {
        switch self {
        case .supplements:
            return "The information about supplements in our application is sourced from iHerb iherb.com."
        case .recipesandDietPlans:
            return "The information about Recipes and Diet Plans in our application is sourced from WebTeb (webteb.com)."
        case .food:
            return "The information about Food in our application is sourced from WebTeb (webteb.com)."
        case .caloricBalanceEquation:
            return "Sourced from Mayo Clinic https://www.mayoclinic.org/healthy-lifestyle/weight-loss/in-depth/calories/art-20048065, a trusted and reputable health resource."
        case .caloriesCalculator:
            return "Based on the Benedict Harris Formula, sourced from Mayo Clinic (https://www.mayoclinic.org/healthy-lifestyle/weight-loss/in-depth/calorie-calculator/itt-20402304), a trusted and reputable health resource."
        }
    }
    
}
