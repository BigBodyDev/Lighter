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
