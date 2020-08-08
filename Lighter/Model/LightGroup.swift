//
//  LightGroup.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI

class LightGroup: ObservableObject  {
    static var `default` = LightGroup(name: "Test Group")
    
    fileprivate var _name: String?
    fileprivate var _state: LightState!
    fileprivate var _color: Color?
    fileprivate var _effect: LightEffect?
    fileprivate var _lights = [Light]()
    
    var name: String?{
        return _name
    }
    var state: LightState{
        return _state
    }
    var color: Color?{
        return _color
    }
    var effect: LightEffect?{
        return _effect
    }
    var lights: [Light]{
        return _lights
    }
    
    init(name: String?) {
        self._name = name
        self._state = .off
    }
    
    init(name: String?, lights: [Light]){
        self._name = name
        self._lights = lights
    }
}
