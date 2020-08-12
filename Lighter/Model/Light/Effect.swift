//
//  Effect.swift
//  Lighter
//
//  Created by Devin Green on 8/10/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit

class Effect{
    typealias EffectValues = (index: Double, colors: [UIColor], iconType: ColorIconType)
    
    static func effect(withIndex index: Double) -> EffectValues {
        switch index {
        case 0:
            return Fade.all
        case 1:
            return Fade.red
        case 2:
            return Fade.green
        case 3:
            return Fade.blue
        case 4:
            return Fade.yellow
        case 5:
            return Fade.cyan
        case 6:
            return Fade.purple
        case 7:
            return Fade.white
        case 8:
            return CrossFade.redGreen
        case 9:
            return CrossFade.redBlue
        case 10:
            return CrossFade.greenBlue
        case 11:
            return Flash.all
        case 12:
            return Flash.red
        case 13:
            return Flash.green
        case 14:
            return Flash.blue
        case 15:
            return Flash.yellow
        case 16:
            return Flash.cyan
        case 17:
            return Flash.purple
        case 18:
            return Flash.white
        case 19:
            return Jump.all
        default:
            return Fade.all
        }
    }
    
    private init(){}
}

class Fade: Effect {
    static let values: [EffectValues] = [Fade.all, Fade.red, Fade.green, Fade.blue, Fade.yellow, Fade.cyan, Fade.purple, Fade.white]
    
    static let all: EffectValues = (0, [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemPink, .systemRed], .wheelGradient)
    static let red: EffectValues = (1, [.systemRed, .black, .black], .twoGradient)
    static let green: EffectValues = (2, [.systemGreen, .black, .black], .twoGradient)
    static let blue: EffectValues = (3, [.systemBlue, .black, .black], .twoGradient)
    static let yellow: EffectValues = (4, [.systemYellow, .black, .black], .twoGradient)
    static let cyan: EffectValues = (5, [.systemTeal, .black, .black], .twoGradient)
    static let purple: EffectValues = (6, [.systemPurple, .black, .black], .twoGradient)
    static let white: EffectValues = (7, [.white, .black, .black], .twoGradient)
}

class CrossFade: Effect {
    static let values: [EffectValues] = [CrossFade.redGreen, CrossFade.redBlue, CrossFade.greenBlue]
    
    static let redGreen: EffectValues = (8, [.systemRed, .systemGreen], .twoGradient)
    static let redBlue: EffectValues = (9, [.systemRed, .systemBlue], .twoGradient)
    static let greenBlue: EffectValues = (10, [.systemGreen, .systemBlue], .twoGradient)
}

class Flash: Effect {
    private static let darkGray = UIColor(white: 0.1, alpha: 1)
    static let values: [EffectValues] = [Flash.all, Flash.red, Flash.green, Flash.blue, Flash.yellow, Flash.cyan, Flash.purple, Flash.white]
    
    static let all: EffectValues = (11, [.systemRed, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemPurple], .slices)
    static let red: EffectValues = (12, [.systemRed, darkGray], .twoSolid)
    static let green: EffectValues = (13, [.systemGreen, darkGray], .twoSolid)
    static let blue: EffectValues = (14, [.systemBlue, darkGray], .twoSolid)
    static let yellow: EffectValues = (15, [.systemYellow, darkGray], .twoSolid)
    static let cyan: EffectValues = (16, [.systemTeal, darkGray], .twoSolid)
    static let purple: EffectValues = (17, [.systemPurple, darkGray], .twoSolid)
    static let white: EffectValues = (18, [.white, darkGray], .twoSolid)
}

class Jump: Effect {
    static let values: [EffectValues] = [Jump.all]
    
    static let all: EffectValues = (19, [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .magenta], .wheelSolid)
}
