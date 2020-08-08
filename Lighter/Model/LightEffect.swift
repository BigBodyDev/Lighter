//
//  LightEffect.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI

class LightEffect: ObservableObject  {
    static var `default` = LightEffect()
    
    enum TransitionType: Int{
        case fade = 0
        case jump = 1
        case pulse = 2
    }
    
    fileprivate var _name: String!
    fileprivate var _colors = [Color]()
    fileprivate var _transitionType: TransitionType!
    fileprivate var _colorDuration: TimeInterval!
    fileprivate var _transitionDuration: TimeInterval!
    
    var name: String{
        return _name
    }
    var colors: [Color]{
        return _colors
    }
    var transitionType: TransitionType{
        return _transitionType
    }
    var colorDuration: TimeInterval{
        return _colorDuration
    }
    var transitionDuration: TimeInterval{
        return _transitionDuration
    }
}
