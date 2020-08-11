//
//  Light.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class Light: ObservableObject, Equatable {
    static var `default` = Light()
    
    enum State: Double{
        case neutral = 0
        case color = 1
        case effect = 2
    }
    
    enum Status: Double{
        case unregistered = 0
        case disconnected = 1
        case connected = 2
    }
    
//    Identification
    @Published private(set) var registeredName: String!
    @Published private(set) var peripheralName: String!
    @Published private(set) var peripheralUUID: UUID!
    
//    State/Status
    @Published private(set) var isOn: Bool!
    @Published private(set) var state: State!
    @Published private(set) var status: Status!
    
//    Configuration
    @Published private(set) var color: UIColor?
    @Published private(set) var effect: Effect.EffectValues?
    @Published private(set) var speed: Double?
    
    
//    Basic Initialization
    init(){
        self.peripheralName = String()
        self.peripheralUUID = UUID()
        self.registeredName = "New Light"
        
        self.isOn = false
        self.state = .neutral
        self.status = .unregistered
    }
    
//    Unregistered Initialization
    init(peripheral: CBPeripheral){
        self.peripheralName = peripheral.name ?? "Triones"
        self.peripheralUUID = peripheral.identifier
        self.registeredName = "New Light"
        
        self.isOn = false
        self.state = .neutral
        self.status = .unregistered
    }
    
//    Disconnected Initialization
    init(cdm: CDMLight){
        self.peripheralName = cdm.peripheralName ?? "Triones"
        self.peripheralUUID = cdm.peripheralUUID
        self.registeredName = cdm.registeredName ?? "New Light"
        
        self.isOn = cdm.isOn
        self.state = State(rawValue: cdm.state) ?? .neutral
        self.status = .disconnected
        
        self.color = UIColor(red: CGFloat(cdm.red), green: CGFloat(cdm.green), blue: CGFloat(cdm.blue), alpha: 1)
        self.effect = Effect.effect(withIndex: cdm.effect)
        self.speed = cdm.speed
    }
    
//    Function to link the disconnected CDMLight with the light peripheral
    func link(withPeripheral peripheral: CBPeripheral){
        self.peripheralName = peripheral.name
        self.peripheralUUID = peripheral.identifier
        
        self.status = .connected
        LightManager.shared.objectWillChange.send()
    }
    
//    Function to remove the CDM copy of the light and add reset the light to just a peripheral
    func removeFromMemory(){
        self.registeredName = "New Light"
        
        self.isOn = false
        self.state = .neutral
        self.status = .unregistered
        
        self.color = nil
        self.effect = nil
        self.speed = nil
        
        LightManager.shared.persist(light: self, withMethod: .delete)
        LightManager.shared.objectWillChange.send()
    }
    
    func changeLightName(_ newName: String){
        self.registeredName = newName
        if self.status == .unregistered{
            self.status = self.peripheralName == String() ? .disconnected : .connected
            LightManager.shared.persist(light: self, withMethod: .post)
        }else{
            LightManager.shared.persist(light: self, withMethod: .put)
        }
        LightManager.shared.objectWillChange.send()
    }
    
    func toggle(){
        self.isOn = !self.isOn
        
        LightManager.shared.setPower(light: self, isOn: self.isOn)
        LightManager.shared.objectWillChange.send()
    }
    
    func setPower(isOn: Bool){
        self.isOn = isOn
        
        LightManager.shared.setPower(light: self, isOn: isOn)
        LightManager.shared.objectWillChange.send()
    }
    
    func setColor(color: UIColor){
        self.effect = nil
        self.color = color
        self.state = .color
        
        LightManager.shared.setColor(light: self, color: color)
        LightManager.shared.objectWillChange.send()
    }
    
    func setEffect(effect: Effect.EffectValues){
        self.color = nil
        self.effect = effect
        self.state = .effect
        
        LightManager.shared.setEffect(light: self, effect: effect)
        LightManager.shared.objectWillChange.send()
    }
    
    
    static func == (lhs: Light, rhs: Light) -> Bool {
        lhs.peripheralUUID == rhs.peripheralUUID
    }
}
