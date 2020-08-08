//
//  LightManager.swift
//  Lighter
//
//  Created by Devin Green on 7/27/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreData
import SwiftUI

class LightManager: NSObject, ObservableObject, CoreBluetoothManagerDelegate{
    
    static let shared = LightManager()
    
    var dataManager: CoreDataManager!
    var bluetoothManager: CoreBluetoothManager!
    
    @Published var lights = [Light]()
    @Published var groups = [LightGroup]()
    
//    var CDMLights = [LightCDM]()
//    var CDMGroups = [LightGroupCDM]()
    
//    override class func discoverLights() {
//        bluetoothCentralManager = CBCentralManager(delegate: self, queue: nil)
//
//
//
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.centralManagerDidUpdateState(self.bluetoothCentralManager)
//        }
//    }
    
    override init(){
        super.init()
        
        self.dataManager = CoreDataManager()
        self.bluetoothManager = CoreBluetoothManager()
        self.bluetoothManager.delegate = self
        
        self.lights = dataManager.lights.map( { lightFromCDMLight(cdmLight: $0, lightStatus: .disconnected)})
        
        self.bluetoothManager.startBluetoothManager()
    }
    
    func didDiscoverLightPeripheral(peripheral: CBPeripheral) {
        if let cdm = dataManager.lights.first(where: { $0.peripheralUUID == peripheral.identifier }){
            let light = lightFromCDMLight(cdmLight: cdm, lightStatus: .connected)
            
            if let index = self.lights.firstIndex(where: { $0.peripheralUUID == light.peripheralUUID }){
                self.lights[index] = light
            }else{
                self.lights.append(light)
            }
        }else if let index = self.lights.firstIndex(where: { $0.peripheralUUID == peripheral.identifier }){
            self.lights[index] = Light(peripheralName: peripheral.name ?? "Triones Light", peripheralUUID: peripheral.identifier)
        }else {
            self.lights.append(Light(peripheralName: peripheral.name ?? "Triones Light", peripheralUUID: peripheral.identifier))
        }
    }
    
    func lightFromCDMLight(cdmLight: CDMLight, lightStatus: Light.Status) -> Light{
        Light(peripheralName: cdmLight.peripheralName ?? "Triones Light", peripheralUUID: cdmLight.peripheralUUID ?? UUID(), registeredName: cdmLight.registeredName ?? "New Light", state: Light.State(rawValue: Int(cdmLight.state)) ?? .off, status: lightStatus, color: Color(red: Double(cdmLight.red) / 255, green: Double(cdmLight.green) / 255, blue: Double(cdmLight.blue) / 255), effect: Light.Effect(rawValue: Int(cdmLight.effect)), speed: Int(cdmLight.speed))
    }
    
    func registerLight(light: Light){
        light.registerLight()
        dataManager.registerLight(light: light)
        bluetoothManager.refresh()
    }
    
    func saveLight(light: Light){
        dataManager.updateLight(light: light)
    }
}
