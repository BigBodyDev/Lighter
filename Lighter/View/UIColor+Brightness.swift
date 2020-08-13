//
//  UIColor+Brightness.swift
//  Lighter
//
//  Created by Devin Green on 8/12/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    var brightness: Double{
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
//            B += (brightness - 1.0)
//            B = max(min(B, 1.0), 0.0)
            
            return Double(B)
        }
        return 0
    }
    
    func color(withBrightness brightness: Double) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (CGFloat(brightness) - 1.0)
            B = max(min(B, 1.0), 0.0)
            
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        
        return self
    }
}
