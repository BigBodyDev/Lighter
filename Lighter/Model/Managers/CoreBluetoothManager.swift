//
//  CoreBluetoothManager.swift
//  Lighter
//
//  Created by Devin Green on 8/3/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol CoreBluetoothManagerDelegate: class {
    func didDiscoverLightPeripheral(peripheral: CBPeripheral)
}

class CoreBluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    weak var delegate: CoreBluetoothManagerDelegate?
    private var bluetoothCentralManager: CBCentralManager!
    
    var peripherals = [CBPeripheral]()
    
    override init() {
        super.init()
        
        self.peripherals = [CBPeripheral]()
    }
    
    func startBluetoothManager(){
        self.bluetoothCentralManager = CBCentralManager(delegate: self, queue: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refresh()
        }
        
//        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
//            self.refresh()
//        }
    }
    
    func refresh(){
        self.centralManagerDidUpdateState(self.bluetoothCentralManager)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
            case .resetting:
                print("Bluetooth is resetting")
            case .unsupported:
                print("Bluetooth is not supported here")
            case .unauthorized:
                print("Bluetooth connections are not authorized")
            case .poweredOff:
                print("Your Bluetooth is currently powered off")
            case .poweredOn:
                self.bluetoothCentralManager.scanForPeripherals(withServices: nil)//[Self.serviceFFD0, Self.serviceFFD5], options: nil)
            default:
                print("Something is wrong with Bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, name.contains("Triones") && !self.peripherals.contains(peripheral){
            self.peripherals.append(peripheral)
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([.serviceFFD0, .serviceFFD5])
        
        if let index = self.peripherals.firstIndex(where: { $0.identifier == peripheral.identifier }){
            self.peripherals.remove(at: index)
        }
        self.peripherals.append(peripheral)
        
        self.delegate?.didDiscoverLightPeripheral(peripheral: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services{
            for service in services{
                peripheral.discoverCharacteristics([.characteristicFFD9, .characteristicFFD4], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.description)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.description)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.description)
    }
    
    class Byte{
        enum ByteType {
            case power, mode, speed, red, green, blue, white
        }
        
        fileprivate var _type: ByteType!
        fileprivate var _value: String!
        
        var type: ByteType{
            return _type
        }
        var value: String{
            return _value
        }
        lazy var interpretedValue: Int = {
            switch self.type {
            case .power:
                return self.value == "23" ? 1 : 0
            case .mode:
                return self.value == "41" ? 0 : 1
            case .speed:
                return self.intValue
            case .red:
                return self.intValue
            case .green:
                return self.intValue
            case .blue:
                return self.intValue
            case .white:
                return self.intValue
            }
        }()
        lazy var description: String = {
            switch self.type {
            case .power:
                return "Power: " + self.value == "23" ? "ON" : "OFF"
            case .mode:
                return "Mode: " + self.value == "41" ? "Static Color" : "Color Effect"
            case .speed:
                return "Speed: \(self.intValue) of 255"
            case .red:
                return "Red: \(self.intValue) of 255"
            case .green:
                return "Green: \(self.intValue) of 255"
            case .blue:
                return "Blue: \(self.intValue) of 255"
            case .white:
                return "White \(self.intValue) of 255"
            }
        }()
        lazy var intValue: Int = {
            let num1 = numberForCharacter(character: String(self.value.uppercased().first ?? "0"))
            let num2 = numberForCharacter(character: String(self.value.uppercased().last ?? "0"))
            
            return (num1 * 16) + num2
        }()
        

        init(type: ByteType, value: String) {
            self._type = type
            self._value = value
        }
        
        private func numberForCharacter(character: String) -> Int{
            switch character {
            case "0":
                return 0
            case "1":
                return 1
            case "2":
                return 2
            case "3":
                return 3
            case "4":
                return 4
            case "5":
                return 5
            case "6":
                return 6
            case "7":
                return 7
            case "8":
                return 8
            case "9":
                return 9
            case "A":
                return 10
            case "B":
                return 11
            case "C":
                return 12
            case "D":
                return 13
            case "E":
                return 14
            case "F":
                return 15
            default:
                return 0
            }
        }
    }

}

extension CBUUID{
    public static let serviceFFD0 = CBUUID(string: "FFD0")
    public static let serviceFFD5 = CBUUID(string: "FFD5")
    public static let characteristicFFD4 = CBUUID(string: "FFD4")
    public static let characteristicFFD9 = CBUUID(string: "FFD9")
}
