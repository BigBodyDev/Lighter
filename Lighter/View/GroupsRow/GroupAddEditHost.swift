//
//  GroupAddEditHost.swift
//  Lighter
//
//  Created by Devin Green on 8/11/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GroupAddEditHost: View {
    @EnvironmentObject var manager: LightManager
    @Binding var linkedLights: [Light]
    @Binding var group: LightGroup
    
    @State var name: String = String()
    @State var selectedLights: [Light] = [Light]()
    
    @Binding var isPresented: Bool
    
    @State var showErrorAlert: Bool = false
    @State var errorAlertMessage: String = String()
    
    var isNew: Bool{
        return group.lights.isEmpty
    }
    
    var body: some View {
        NavigationView {
            
            VStack{
                ZStack{
                    BackgroundView()
                        .frame(height: 55)
                    
                    TextField("Light Group", text: self.$name)
                        .autocapitalization(.words)
                        .padding()
                }
                .padding(.horizontal)
                
                if !self.isNew {
                    Button(action: {
                        self.manager.removeLightGroup(group: self.group)
                        self.isPresented.toggle()
                    }) {
                        ZStack{
                            BackgroundView()
                                .frame(height: 55)
                            
                            Text("Delete Light Group")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .padding([.bottom, .horizontal])
                }
                
                List{
                    Section(header: Text("Lights")) {
                        ForEach(self.manager.lights.indices) { index in
                            if self.manager.lights[index].status != .unregistered{
                                LightOptionRow(selectedLights: self.$selectedLights, light: self.$manager.lights[index])
                            }
                        }
                    }
                }
            }
            
            .navigationBarTitle(Text(self.isNew ? "New Light Group" : "Edit Light Group"))
            .navigationBarItems(trailing: Button(action: {
                if self.selectedLights.count < 2{
                    self.errorAlertMessage = "Please select at least two lights to save this group"
                    self.showErrorAlert.toggle()
                    
                }else if ({
                    for group in self.manager.groups{
                        if group.lights.sorted().elementsEqual(self.selectedLights.sorted()) && group != self.group{
                            return true
                        }
                    }
                    return false
                }()){
                    self.errorAlertMessage = "This light selection has already been used in a prior light group"
                    self.showErrorAlert.toggle()
                    
                }else if self.isNew{
                    let group = LightGroup(name: self.name == String() ? "New Group" : self.name, lights: self.selectedLights)
                    self.manager.addLightGroup(group: group)
                    
                    self.isPresented.toggle()
                }else{
                    if self.group.name != self.name{
                        self.group.setName(name: self.name)
                    }
                    
                    if !self.group.lights.sorted().elementsEqual(self.selectedLights.sorted()){
                        self.group.setLights(lights: self.selectedLights)
                    }
                    
                    self.isPresented.toggle()
                }
            }, label: {
                Text("Save")
            }))
                .alert(isPresented: self.$showErrorAlert) { () -> Alert in
                    Alert(title: Text("Light Group Save Error"), message: Text(self.errorAlertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct GroupAddEditHost_Previews: PreviewProvider {
    static var previews: some View {
        GroupAddEditHost(linkedLights: .constant([]), group: .constant(.default), isPresented: .constant(false))
    }
}
