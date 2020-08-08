//
//  LightManager.swift
//  Lighter
//
//  Created by Devin Green on 7/27/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI

class LightManager: ObservableObject{
    static let shared = LightManager()
    
    @Published var lights = [Light]()
    @Published var groups = [LightGroup]()
    @Published var effects = [LightEffect]()
    
    
    func discover(light: Light){
        self.lights.append(light)
        
        print(lights)
    }
}
