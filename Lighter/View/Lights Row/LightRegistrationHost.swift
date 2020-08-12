//
//  LightRegistrationHost.swift
//  Lighter
//
//  Created by Devin Green on 8/9/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct LightRegistrationHost: View {
    @EnvironmentObject var manager: LightManager
    @Binding var light: Light
    
    @State var lightName: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ZStack{
                        BackgroundView()
                        
                        TextField("New Light", text: self.$lightName)
                            .autocapitalization(.words)
                            .padding()
                    }
                    
                    if self.light.status != .unregistered {
                        Button(action: {
                            self.light.removeFromMemory()
                            self.isPresented.toggle()
                        }) {
                            ZStack{
                                BackgroundView()
                                
                                Text("Delete Light")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(Text(self.light.status == .unregistered ? "Add light to collection" : "Change light name"))
            .navigationBarItems(trailing: Button(action: {
                self.light.setName(name: self.lightName == String() ? "New Light" : self.lightName)
                self.isPresented.toggle()
            }, label: {
                Text(self.light.status == .unregistered ? "Register" : "Update")
            }))
        }
    }
}

struct LightRegistrationHost_Previews: PreviewProvider {
    static var previews: some View {
        LightRegistrationHost(light: .constant(Light()), lightName: "Light", isPresented: .constant(true))
    }
}
