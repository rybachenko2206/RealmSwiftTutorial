//
//  UIViewController+Methods.swift
//  BudgetControl
//
//  Created by Roman Rybachenko on 1/7/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class var storyboardIdentifier: String {
        return String(describing: self)
    }
}

