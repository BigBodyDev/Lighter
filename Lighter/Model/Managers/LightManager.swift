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
import UIKit

class LightManager: NSObject, ObservableObject, CoreBluetoothManagerDelegate{
    static let shared = LightManager()
    
    var dataManager: CoreDataManager!
    var bluetoothManager: CoreBluetoothManager!
    
    @Published var lights = [Light]()
    @Published var groups = [LightGroup]()
    
    @Published var speed: Double = 0.5
    @Published var brightness: Double = 0.5
    
    typealias CBWritingItems = (peripheral: CBPeripheral?, characteristic: CBCharacteristic?)
    static func writingItems(forLight light: Light, withServiceID serviceID: CBUUID, withCharacteristicID characteristicID: CBUUID) -> CBWritingItems{
        
        return (Self.shared.bluetoothManager.peripherals.first(where: { $0.identifier == light.peripheralUUID }), Self.shared.bluetoothManager.peripherals.first(where: { $0.identifier == light.peripheralUUID })?.services?.first(where: { $0.uuid == serviceID })?.characteristics?.first(where: { $0.uuid == characteristicID }))
    }
    
    override init(){
        super.init()
        
        self.speed = UserDefaults.standard.value(forKey: UserDefaults.SPEED_KEY) as? Double ?? 0.5
        self.brightness = UserDefaults.standard.value(forKey: UserDefaults.BRIGHTNESS_KEY) as? Double ?? 0.5
        
        self.dataManager = CoreDataManager()
        self.lights = dataManager.lights.map( { Light(cdm: $0) })
        self.groups = dataManager.groups.map( { LightGroup(cdm: $0) })
        
        self.bluetoothManager = CoreBluetoothManager()
        self.bluetoothManager.delegate = self
        self.bluetoothManager.startBluetoothManager()
    }
    
    func didDiscoverLightPeripheral(peripheral: CBPeripheral) {
        if let index = self.lights.firstIndex(where: { $0.peripheralUUID == peripheral.identifier }){
            self.lights[index].link(withPeripheral: peripheral)
        }else{
            self.lights.append(Light(peripheral: peripheral))
        }
    }
    
    func addLightGroup(group: LightGroup){
        self.groups.append(group)
        self.persist(group: group, withMethod: .post)
    }
    
    func removeLightGroup(group: LightGroup){
        if let index = self.groups.firstIndex(of: group){
            self.groups.remove(at: index)
            self.persist(group: group, withMethod: .delete)
        }
    }
    
    func persist(light: Light, withMethod method: CoreDataManager.ChangeMethod){
        dataManager.persist(light: light, withMethod: method)
    }
    
    func persist(group: LightGroup, withMethod method: CoreDataManager.ChangeMethod){
        dataManager.persist(group: group, withMethod: method)
    }
    
    func setPower(light: Light, isOn: Bool){
        let items = Self.writingItems(forLight: light, withServiceID: .serviceFFD5, withCharacteristicID: .characteristicFFD9)
        
        if let peripheral = items.peripheral, let ffd9 = items.characteristic{
            let payload: [UInt8] = [0xCC, isOn ? 0x23 : 0x24, 0x33]
            let data = Data(bytes: payload, count: 3)
            peripheral.writeValue(data, for: ffd9, type: .withoutResponse)
            
            persist(light: light, withMethod: .put)
        }
    }
    
    func setColor(light: Light, color: UIColor){
        let items = Self.writingItems(forLight: light, withServiceID: .serviceFFD5, withCharacteristicID: .characteristicFFD9)
        let color = color.color(withBrightness: self.brightness)
        
        if let peripheral = items.peripheral, let ffd9 = items.characteristic, let red = UInt8(exactly: Int(color.components.red * 255)), let green = UInt8(exactly: Int(color.components.green * 255)), let blue = UInt8(exactly: Int(color.components.blue * 255)) {
            
            let payload: [UInt8] = [0x56, red, green, blue, 0x00, 0xF0, 0xAA]
            let data = Data(bytes: payload, count: 7)
            peripheral.writeValue(data, for: ffd9, type: .withoutResponse)
            
            persist(light: light, withMethod: .put)
        }
    }
    
    func setEffect(light: Light, effect: Effect.EffectValues){
        let items = Self.writingItems(forLight: light, withServiceID: .serviceFFD5, withCharacteristicID: .characteristicFFD9)
        
        if let peripheral = items.peripheral, let ffd9 = items.characteristic {
            
            let payload: [UInt8] = [0xBB, 0x25 + UInt8(effect.index), UInt8(exactly: 255 - Int(self.speed * 255))!, 0x44]
            let data = Data(bytes: payload, count: 4)
            peripheral.writeValue(data, for: ffd9, type: .withoutResponse )
            
            persist(light: light, withMethod: .put)
        }
    }
    
    func setBrightness(light: Light, brightness: Double){
        UserDefaults.standard.set(brightness, forKey: UserDefaults.BRIGHTNESS_KEY)
        self.brightness = brightness
        
        let items = Self.writingItems(forLight: light, withServiceID: .serviceFFD5, withCharacteristicID: .characteristicFFD9)
        let color = light.color!.color(withBrightness: brightness)
        
        if let peripheral = items.peripheral, let ffd9 = items.characteristic, let red = UInt8(exactly: Int(color.components.red * 255)), let green = UInt8(exactly: Int(color.components.green * 255)), let blue = UInt8(exactly: Int(color.components.blue * 255)) {
            
            let payload: [UInt8] = [0x56, red, green, blue, 0x00, 0xF0, 0xAA]
            let data = Data(bytes: payload, count: 7)
            peripheral.writeValue(data, for: ffd9, type: .withoutResponse)
        }
    }
    
    func setSpeed(light: Light, speed: Double){
        UserDefaults.standard.set(speed, forKey: UserDefaults.SPEED_KEY)
        self.speed = speed
        
        print(speed)
        print(speed * 255)
        print(Int(speed * 255))
        print(255 - Int(speed * 255))
        print(UInt8(exactly: 255 - Int(speed * 255))!)
        print()
        
        let items = Self.writingItems(forLight: light, withServiceID: .serviceFFD5, withCharacteristicID: .characteristicFFD9)
        
        if let peripheral = items.peripheral, let ffd9 = items.characteristic {
//            print(255 - Int(speed * 255))
            
            let payload: [UInt8] = [0xBB, 0x25 + UInt8(light.effect!.index), UInt8(exactly: 255 - Int(speed * 255))! , 0x44]
            let data = Data(bytes: payload, count: 4)
            peripheral.writeValue(data, for: ffd9, type: .withoutResponse )
        }
    }
}
