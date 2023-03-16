//
//  UILayoutPriority+Constants.swift
//  AutoLayouts
//
//  Created by Bijan Nazem on 2023-02-10.
//

import UIKit

extension UILayoutPriority {
    static let defaultBelowLow = UILayoutPriority(UILayoutPriority.defaultLow.rawValue - 1)
    static let defaultAboveLow = UILayoutPriority(UILayoutPriority.defaultLow.rawValue + 1)
    static let defaultBelowHigh = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue - 1)
    static let defaultAboveHigh = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue + 1)
}
