//
//  Colors.swift
//  Lighter
//
//  Created by Devin Green on 8/3/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    
    typealias ColorComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    var components: ColorComponents {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
