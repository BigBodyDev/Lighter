//
//  Light.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI

enum LightState: Int{
    case off = 0
    case color = 1
    case effect = 2
}

class Light: ObservableObject {
    static var `default` = Light(peripheralName: "Triones", peripheralUUID: UUID(), registeredName: "Test Light")
    
    fileprivate var _peripheralName: String!
    fileprivate var _peripheralUUID: UUID!
    fileprivate var _registeredName: String?
    fileprivate var _state: LightState!
    fileprivate var _color: Color?
    fileprivate var _effect: LightEffect?
    
    var peripheralName: String{
        return _peripheralName
    }
    var peripheralUUID: UUID{
        return _peripheralUUID
    }
    var registeredName: String?{
        return _registeredName
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
    
    init(peripheralName: String, peripheralUUID: UUID){
        self._peripheralName = peripheralName
        self._peripheralUUID = peripheralUUID
        self._state = .off
    }
    
    init(peripheralName: String, peripheralUUID: UUID, registeredName: String?){
        self._peripheralName = peripheralName
        self._peripheralUUID = peripheralUUID
        self._registeredName = registeredName
        self._state = .off
    }
}
