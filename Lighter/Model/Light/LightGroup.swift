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
    static var `default` = LightGroup()
    
//    Identification
    fileprivate var _name: String!
    fileprivate var _UUID: UUID!
    var name: String{
        return _name
    }
    var UUID: UUID{
        return _UUID
    }
    
//    State/Status
    fileprivate var _state: Light.State!
    fileprivate var _status: Light.Status!
    var state: Light.State{
        return _state
    }
    var status: Light.Status{
        return _status
    }
    
//    Configuration
    fileprivate var _color: Color?
    fileprivate var _effect: Light.Effect?
    fileprivate var _speed: Int?
    var color: Color?{
        return _color
    }
    var effect: Light.Effect?{
        return _effect
    }
    var speed: Int?{
        return _speed
    }

//    Lights
    fileprivate var _lights = [Light]()
    var lights: [Light]{
        return _lights
    }
    
//    init(name: String?) {
//        self._name = name
//        self._state = .off
//    }
//
//    init(name: String?, lights: [Light]){
//        self._name = name
//        self._lights = lights
//    }
}
