//
//  SwiftUI+Color.swift
//  Lighter
//
//  Created by Devin Green on 8/3/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension SwiftUI.Color {
    var redComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let r1 = val.index(val.startIndex, offsetBy: 1)
        let r2 = val.index(val.startIndex, offsetBy: 2)
        return Int(val[r1...r2], radix: 16)!
    }

    var greenComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let g1 = val.index(val.startIndex, offsetBy: 3)
        let g2 = val.index(val.startIndex, offsetBy: 4)
        return Int(val[g1...g2], radix: 16)!
    }

    var blueComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 5)
        let b2 = val.index(val.startIndex, offsetBy: 6)
        return Int(val[b1...b2], radix: 16)!
    }

    var alphaComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 7)
        let b2 = val.index(val.startIndex, offsetBy: 8)
        return Int(val[b1...b2], radix: 16)!
    }
}

extension UIColor {
    func hexValue() -> String {
        let values = self.cgColor.components
        var outputR: Int = 0
        var outputG: Int = 0
        var outputB: Int = 0
        var outputA: Int = 1

        switch values!.count {
            case 1:
                outputR = Int(values![0] * 255)
                outputG = Int(values![0] * 255)
                outputB = Int(values![0] * 255)
                outputA = 1
            case 2:
                outputR = Int(values![0] * 255)
                outputG = Int(values![0] * 255)
                outputB = Int(values![0] * 255)
                outputA = Int(values![1] * 255)
            case 3:
                outputR = Int(values![0] * 255)
                outputG = Int(values![1] * 255)
                outputB = Int(values![2] * 255)
                outputA = 1
            case 4:
                outputR = Int(values![0] * 255)
                outputG = Int(values![1] * 255)
                outputB = Int(values![2] * 255)
                outputA = Int(values![3] * 255)
            default:
                break
        }
        return "#" + String(format:"%02X", outputR) + String(format:"%02X", outputG) + String(format:"%02X", outputB) + String(format:"%02X", outputA)
    }
}
