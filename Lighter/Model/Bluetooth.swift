//
//  Bluetooth.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreBluetooth

class Bluetooth: NSObject, ObservableObject{//, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = Bluetooth()
    private var centralManager: CBCentralManager!
    @Published var peripherals = [CBPeripheral]()
    
    public static let service1UUID = CBUUID(string: "FFD0")
    public static let service2UUID = CBUUID(string: "FFD5")
    public static let characteristic1UUID = CBUUID(string: "FFD4")
    public static let characteristic2UUID = CBUUID(string: "FFD9")
    
    override init(){
        super.init()
    }
    
    func startBluetoothManager(){
        
    }
    
    private func scan(){
        
    }
    
    
    
    func sniffPeripheral(_ peripheral: CBPeripheral) {
        
    }
    
    func decodePeripheralResponse(_ value: Data){
    }
    
    
    
    
}




/* Next Steps
 
 1. Make the Bluetooth and LightManager classes one thing
 2. Add the color and states back to the core data model
 3. Add all of the core data functionality
 
 */
