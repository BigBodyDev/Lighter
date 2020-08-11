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
    typealias EffectValues = (index: Double, colors: [UIColor], EffectIconType)
    
    enum EffectIconType: Int{
        case wheel = 0
        case diagnol = 1
        case wheelGradient = 2
        case diagnolGradient = 3
    }
    
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
    
    static let all: EffectValues = (0, [.red, .orange, .yellow, .green, .blue, .purple], .wheelGradient)
    static let red: EffectValues = (1, [.red, .black], .diagnolGradient)
    static let green: EffectValues = (2, [.green, .black], .diagnolGradient)
    static let blue: EffectValues = (3, [.systemBlue, .black], .diagnolGradient)
    static let yellow: EffectValues = (4, [.systemYellow, .black], .diagnolGradient)
    static let cyan: EffectValues = (5, [.cyan, .black], .diagnolGradient)
    static let purple: EffectValues = (6, [.systemPurple, .black], .diagnolGradient)
    static let white: EffectValues = (7, [.white, .black], .diagnolGradient)
}

class CrossFade: Effect {
    static let values: [EffectValues] = [CrossFade.redGreen, CrossFade.redBlue, CrossFade.greenBlue]
    
    static let redGreen: EffectValues = (8, [.red, .green], .diagnolGradient)
    static let redBlue: EffectValues = (9, [.red, .blue], .diagnolGradient)
    static let greenBlue: EffectValues = (10, [.green, .blue], .diagnolGradient)
}

class Flash: Effect {
    static let values: [EffectValues] = [Flash.all, Flash.red, Flash.green, Flash.blue, Flash.yellow, Flash.cyan, Flash.purple, Flash.white]
    
    static let all: EffectValues = (11, [.red, .orange, .yellow, .green, .blue, .purple], .diagnol)
    static let red: EffectValues = (12, [.red, .black], .diagnol)
    static let green: EffectValues = (13, [.green, .black], .diagnol)
    static let blue: EffectValues = (14, [.systemBlue, .black], .diagnol)
    static let yellow: EffectValues = (15, [.systemYellow, .black], .diagnol)
    static let cyan: EffectValues = (16, [.cyan, .black], .diagnol)
    static let purple: EffectValues = (17, [.systemPurple, .black], .diagnol)
    static let white: EffectValues = (18, [.white, .black], .diagnol)
}

class Jump: Effect {
    static let values: [EffectValues] = [Jump.all]
    
    static let all: EffectValues = (19, [.red, .orange, .yellow, .green, .blue, .purple], .wheel)
}
