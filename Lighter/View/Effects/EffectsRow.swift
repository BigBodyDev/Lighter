//
//  EffectsRow.swift
//  Lighter
//
//  Created by Devin Green on 8/10/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

enum EffectsRowType: String{
    case fade = "Fade"
    case crossFade = "Cross Fade"
    case flash = "Flash"
    case jump = "Jump"
}

struct EffectsRow: View {
    @EnvironmentObject var manager: LightManager
    @Binding var linkedLights: [Light]
    var rowType: EffectsRowType
    
    var effects: [Effect.EffectValues] {
        switch rowType {
        case .fade:
            return Fade.values
        case .crossFade:
            return CrossFade.values
        case .flash:
            return Flash.values
        case .jump:
            return Jump.values
        }
    }
    
    func itemForCoordinates(x: Int, y: Int) -> some View{
        let index = (y * 6) + x
        
        var showIndication: Bool{
            if index < self.effects.count{
                var count = 0
                for light in linkedLights{
                    if let effectIndex = light.effect?.index, effectIndex == self.effects[index].index, light.state == .effect{
                        count += 1
                    }
                }
                return linkedLights.count != 0 && linkedLights.count == count
            }
            return false
        }
        
        return Group{
            if index < self.effects.count{
                ZStack{
                    BackgroundView(color: Color(self.effects[index].colors[0]))
                        .onTapGesture {
                            for x in self.linkedLights.indices{
                                self.linkedLights[x].setEffect(effect: self.effects[index])//.setColor(color: self.colors[index])
                            }
                    }
                    
                    if showIndication{
                        Circle()
                            .fill(Color.white)
                            .padding(15)
                    }
                }
            }else{
                BackgroundView(color: .clear)
            }
        }
        .aspectRatio(1, contentMode: .fill)
    }
    
    var body: some View {
        let columnCount = (self.effects.count / 6) + (self.effects.count % 6 == 0 ? 0 : 1)
        
        return VStack(alignment: .leading){
            Text(self.rowType.rawValue)
                .font(.headline)
                .padding(.horizontal, 25)
            
            VStack{
                ForEach(0..<columnCount, id: \.self){ y in
                    HStack{
                        ForEach(0..<6, id: \.self){ x in
                            self.itemForCoordinates(x: x, y: y)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct EffectsRow_Previews: PreviewProvider {
    static var previews: some View {
        EffectsRow(linkedLights: .constant([]), rowType: .fade)
    }
}
