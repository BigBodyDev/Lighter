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
    
    var lightStatesEqual: Bool {
        var colorCount = 0
        var effectCount = 0
        for light in self.linkedLights{
            colorCount += light.state == .color ? 1 : 0
            effectCount += light.state == .effect ? 1 : 0
        }
        return !self.linkedLights.isEmpty && (colorCount == self.linkedLights.count || effectCount == self.linkedLights.count)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing){
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        Group{
                            LightsRow(linkedLights: self.$linkedLights)
                            
                            GroupsRow(linkedLights: self.$linkedLights)
                            
                            ColorsView(linkedLights: self.$linkedLights)
                            
                            EffectsBlock(linkedLights: self.$linkedLights)
                        }
                        .padding(.bottom, 15)
                        
                    }
                }
                
                if lightStatesEqual{
                    SBView(speed: self.$manager.speed, brightness: self.$manager.brightness, linkedLights: self.$linkedLights)
                        .padding([.horizontal, .top])
                        .padding(.bottom, 35)
                }
            }
            
            .navigationBarTitle("Lighter")
        }
    }
}

struct MainHost_Previews: PreviewProvider {
    static var previews: some View {
        MainHost()
            .environmentObject(LightManager.shared)
    }
}
