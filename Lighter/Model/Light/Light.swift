//
//  Light.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI

class Light: ObservableObject {
    static var `default` = Light(peripheralName: "Triones Light", peripheralUUID: UUID())
    
    enum State: Int{
        case off = 0
        case color = 1
        case effect = 2
    }
    
    enum Status: Int{
        case unregistered = 0
        case disconnected = 1
        case connected = 2
    }
    
    enum Effect: Int{
        case allFade = 0
        case redFade = 1
        case greenFade = 2
        case blueFade = 3
        case yellowFade = 4
        case tealFade = 5
        case purpleFade = 6
        case whiteFade = 7
        
        case redGreenFade = 8
        case redBlueFade = 9
        case greenBlueFade = 10
        
        case allFlash = 11
        case redFlash = 12
        case greenFlash = 13
        case blueFlash = 14
        case yellowFlash = 15
        case tealFlash = 16
        case purpleFlash = 17
        case whiteFlash = 18
        
        case allJump = 19
    }
    
//    Identification
    var registeredName: String!
    
    fileprivate var _peripheralName: String!
    fileprivate var _peripheralUUID: UUID!
    var peripheralName: String{
        return _peripheralName
    }
    var peripheralUUID: UUID{
        return _peripheralUUID
    }
    
//    State/Status
    var state: State!
    
    fileprivate var _status: Status!
    var status: Status{
        return _status
    }
    
//    Configuration
    var color: Color?
    var effect: Effect?
    var speed: Int?
    
//    Unregistered Initialization
    init(peripheralName: String, peripheralUUID: UUID){
        self._peripheralName = peripheralName
        self._peripheralUUID = peripheralUUID
        self.registeredName = "New Light"
        
        self.state = .off
        self._status = .unregistered
    }
    
//    Registered Initialization
    init(peripheralName: String, peripheralUUID: UUID, registeredName: String, state: State, status: Status, color: Color?, effect: Effect?, speed: Int?){
        self._peripheralName = peripheralName
        self._peripheralUUID = peripheralUUID
        self.registeredName = registeredName
        
        self.state = state
        self._status = status
        
        self.color = color
        self.effect = effect
        self.speed = speed
    }
    
    func registerLight(){
        self._status = .connected
    } 
    
//    init(peripheralName: String, peripheralUUID: UUID){
//        self._peripheralName = peripheralName
//        self._peripheralUUID = peripheralUUID
//        self._state = .off
//        self._connection = .unregistered
//    }
//
//    init(peripheralName: String, peripheralUUID: UUID, registeredName: String){
//        self._peripheralName = peripheralName
//        self._peripheralUUID = peripheralUUID
//        self.registeredName = registeredName
//        self._state = .off
//        self._connection = .disconnected
//    }
//
//    init(peripheralName: String, peripheralUUID: UUID, bytes: [Byte]){
//        self._peripheralName = peripheralName
//        self._peripheralUUID = peripheralUUID
//
//        if let power = bytes.first(where: { $0.type == .power }), let mode = bytes.first(where: { $0.type == .mode }){
//            if power.interpretedValue == 0 {
//                self._state = .off
//            }else if mode.interpretedValue == 0 {
//                self._state = .color
//            }else if mode.interpretedValue == 1 {
//                self._state = .effect
//            }
//        }
//
//        if let red = bytes.first(where: { $0.type == .red }), let green = bytes.first(where: { $0.type == .green }), let blue = bytes.first(where: { $0.type == .blue }){
//            self._color = Color(red: Double(red.intValue), green: Double(green.intValue), blue: Double(blue.intValue))
//        }
//
//        self._connection = .connected
//    }
}
