//
//  LightGroup.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit

class LightGroup: ObservableObject  {
    static var `default` = LightGroup()
    
//    Identification
    private(set) var name: String!
    private(set) var UUID: UUID!
    
//    State/Status
    private(set) var isOn: Bool!
    private(set) var state: Light.State!
    private(set) var status: Light.Status!
    
//    Configuration
    private(set) var color: UIColor?
    private(set) var effect: Effect.EffectValues?
    private(set) var speed: Double?

//    Lights
    private(set) var lights = [Light]()
    
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
