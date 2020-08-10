//
//  LightsRow.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct LightsRow: View {
    @Binding var lights: [Light]
    
    @Binding var linkedLights: [Light]
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack {
                Text("Lights")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                
                Spacer()
                
                Button(action: {
                    self.linkedLights = self.linkedLights.count == self.lights.count ? [] : self.lights
                }) {
                    Text(linkedLights.count == lights.count ? "Deselect all" : "Select all")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 25)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(self.lights.indices, id: \.self) { index in
                        LightItem(light: self.$lights[index], linkedLights: self.$linkedLights)
                            .padding(.leading, index == 0 ? 20 : 0)
                            .padding(.trailing, index == self.lights.count - 1 ? 20 : 0)
                    }
                }
                .frame(height: 125)
            }
        }
    }
}

struct LightsRow_Previews: PreviewProvider {
    static var previews: some View {
        LightsRow(lights: .constant([.default, .default]), linkedLights: .constant([]))
    }
}
