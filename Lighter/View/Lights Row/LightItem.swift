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
    
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                BackgroundView()

                AlertControlView(textString: self.$light.registeredName, showAlert: self.$showAlert, title: light.status == .unregistered ? "Add light to collection" : "Edit light name", message: light.status == .unregistered ? "Enter the name of this light to control it" : "Change the name of this light", placeholder: "New Light") {
                    
                    self.light.status == .unregistered ? self.manager.registerLight(light: self.light) : self.manager.saveLight(light: self.light)
                }

                ZStack(alignment: .center){
                    Image(systemName: light.state == .off ? "lightbulb" : "lightbulb.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(30)
                        .foregroundColor(light.color ?? .white)

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
            .onTapGesture(count: 2, perform: {
                self.showAlert.toggle()
            })
                .onTapGesture(count: 1) {
                    if self.light.status == .unregistered {
                        
                    }
            }

            Text(light.registeredName)
                .font(.footnote)
                .frame(height: 20)
        }
    }
}

struct LightItem_Previews: PreviewProvider {
    static var previews: some View {
        LightItem(light: .constant(.default))
    }
}
