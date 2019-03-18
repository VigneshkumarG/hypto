//
//  Storyboarded.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//
import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)                
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
