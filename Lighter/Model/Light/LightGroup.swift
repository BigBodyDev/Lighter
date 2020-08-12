//
//  LightGroup.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit

class LightGroup: ObservableObject, Equatable {
    static var `default` = LightGroup()
    
//    Identification
    private(set) var name: String!
    private(set) var uuid: UUID!

//    Lights
    private var lightIds = [UUID]()
    var lights: [Light] {
        return self.lightIds.map({ id in LightManager.shared.lights.first(where: { $0.peripheralUUID == id })! })
    }
    
    init(){
        self.name = String()
        self.uuid = UUID()
    }
    
    init(name: String, lights: [Light]){
        self.name = name
        self.uuid = UUID()
        
        self.lightIds = lights.map({ $0.peripheralUUID })
    }
    
    init(cdm: CDMLightGroup){
        self.name = cdm.name ?? "New Group"
        self.uuid = cdm.uuid
        
        self.lightIds = (cdm.lights!.allObjects as! [CDMLight]).map({ $0.peripheralUUID! })
    }
    
    func setName(name: String){
        self.name = name
        LightManager.shared.persist(group: self, withMethod: .put)
    }
    
    func setLights(lights: [Light]){
        self.lightIds = lights.map({ $0.peripheralUUID })
        
        LightManager.shared.persist(group: self, withMethod: .put)
    }
    
    func toggle(){
        let condition = self.lights.contains(where: { !$0.isOn })
        for id in self.lightIds{
            guard let index = LightManager.shared.lights.firstIndex(where: { $0.peripheralUUID == id}) else { return }
            LightManager.shared.lights[index].setPower(isOn: condition)
        }
    }
    
    func setPower(isOn: Bool){
        for id in self.lightIds{
            guard let index = LightManager.shared.lights.firstIndex(where: { $0.peripheralUUID == id}) else { return }
            LightManager.shared.lights[index].setPower(isOn: isOn)
        }
    }
    
    func setColor(color: UIColor){
        for id in self.lightIds{
            guard let index = LightManager.shared.lights.firstIndex(where: { $0.peripheralUUID == id}) else { return }
            LightManager.shared.lights[index].setColor(color: color)
        }
    }
    
    func setEffect(effect: Effect.EffectValues){
        for id in self.lightIds{
            guard let index = LightManager.shared.lights.firstIndex(where: { $0.peripheralUUID == id}) else { return }
            LightManager.shared.lights[index].setEffect(effect: effect)
        }
    }
    
    static func == (lhs: LightGroup, rhs: LightGroup) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
