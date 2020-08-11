//
//  LightItem.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct LightItem: View {
    @EnvironmentObject var manager: LightManager
    @Binding var light: Light
    @Binding var linkedLights: [Light]
    
    @State var showRegistration: Bool = false
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                
                BackgroundView(color: self.linkedLights.contains(self.light) ? .blue : nil)
                
                ZStack(alignment: .center){
                    if light.status == .connected {
                        Image(systemName: light.isOn ? "lightbulb.fill" : "lightbulb")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(light.color ?? .white))
                            .frame(width: 30, height: 40)
                    }
                    
                    Image(systemName: light.status != .connected ? "lightbulb.slash" : "lightbulb")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 40)
                    
                    Group{
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                        
                        Circle()
                            .fill(light.status == .unregistered ? Color.red : light.status == .disconnected ? Color.yellow : Color.green)
                    }
                    .frame(width: 15, height: 15)
                    .padding(.leading, 25)
                        .padding(.top, -25)
                }
            }
            .frame(width: 100, height: 100)
            .onTapGesture(count: 2) {
                self.showRegistration.toggle()
            }
            .onTapGesture(count: 1) {
                if self.light.status == .unregistered {
                    self.showRegistration.toggle()
                }else if self.linkedLights.contains(self.light){
                    let condition = self.linkedLights.contains(where: { !$0.isOn })
                    
                    for index in self.manager.lights.indices {
                        if self.linkedLights.contains(self.manager.lights[index]) {
                            self.manager.lights[index].setPower(isOn: condition)
                        }
                    }
                }else{
                    self.light.toggle()
                }
            }
            .onLongPressGesture {
                if self.light.status == .unregistered {
                    self.showRegistration.toggle()
                }else if let index = self.linkedLights.firstIndex(of: self.light){
                    self.linkedLights.remove(at: index)
                }else{
                    self.linkedLights.append(self.light)
                }
            }

            Text(light.registeredName)
                .font(.footnote)
                .frame(height: 20)
        }
        .sheet(isPresented: self.$showRegistration) {
            LightRegistrationHost(light: self.$light, lightName: self.light.registeredName == "New Light" ? String() : self.light.registeredName, showRegistration: self.$showRegistration)
                .environmentObject(self.manager)
        }
    }
}

struct LightItem_Previews: PreviewProvider {
    static var previews: some View {
        LightItem(light: .constant(.default), linkedLights: .constant([]))
    }
}
