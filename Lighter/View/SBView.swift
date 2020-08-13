//
//  SBView.swift
//  Lighter
//
//  Created by Devin Green on 8/12/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct SBView: View {
    @EnvironmentObject var manager: LightManager
    @Binding var speed: Double
    @Binding var brightness: Double
    @Binding var linkedLights: [Light]
    
    var groupState: Light.State{
        var colorCount = 0
        var effectCount = 0
        for light in self.linkedLights{
            colorCount += light.state == .color ? 1 : 0
            effectCount += light.state == .effect ? 1 : 0
        }
        return colorCount == self.linkedLights.count ? .color : effectCount == self.linkedLights.count ? .effect : .neutral
    }
    
    var body: some View {
        
        let value = Binding<Double>(get: {
            if self.groupState == .color{
                return self.brightness * 100
            }else if self.groupState == .effect{
                return self.speed * 100
            }
            return 0.5 * 100
        }, set: {
            let percentage = $0 / 100

            if self.groupState == .color{
                self.brightness = percentage
                
                for light in self.linkedLights{
                    light.setBrightness(brightness: percentage)
                }
                
                LightManager.shared.brightness = percentage
                UserDefaults.standard.set(percentage, forKey: UserDefaults.BRIGHTNESS_KEY)
                
            }else if self.groupState == .effect{
                self.speed = percentage
                
                for light in self.linkedLights{
                    light.setSpeed(speed: percentage)
                }
                
                LightManager.shared.speed = percentage
                UserDefaults.standard.set(percentage, forKey: UserDefaults.SPEED_KEY)
            }
            
        })
        
        return VStack{
            ZStack{
                BackgroundView(color: Color(white: 0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: groupState == .color ? "sun.max.fill" : "hare.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
            
            SBSlider(percentage: value, minPercentage: self.groupState == .color ? 5 : 0, maxPercentage: self.groupState == .color ? 100 : 254 / 255 * 100)
                .frame(width: 50, height: 225)
        }
        
        
    }
}

struct SBView_Previews: PreviewProvider {
    static var previews: some View {
        SBView(speed: .constant(0.5), brightness: .constant(0.5), linkedLights: .constant([]))
    }
}
