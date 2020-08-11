//
//  MainHost.swift
//  Lighter
//
//  Created by Devin Green on 7/25/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct MainHost: View {
    @EnvironmentObject var manager: LightManager
    
    @State var linkedLights: [Light] = [Light]()
    
    var body: some View {
        NavigationView {
            List {
                
                Group{
                    LightsRow(lights: self.$manager.lights, linkedLights: self.$linkedLights)
                    
                    GroupsRow(groups: self.$manager.groups)
                    
                    EffectsBlock(linkedLights: self.$linkedLights)
                    
                    ColorsView(linkedLights: self.$linkedLights)
                }
                .padding(.horizontal, -20)
                .padding(.bottom, 15)
                
            }
            .navigationBarTitle("Lighter")
//            .listRowBackground(Color.clear)
        }
    }
}

struct MainHost_Previews: PreviewProvider {
    static var previews: some View {
        MainHost()
            .environmentObject(LightManager.shared)
    }
}
