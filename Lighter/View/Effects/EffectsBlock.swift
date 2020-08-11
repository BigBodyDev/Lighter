//
//  EffectsBlock.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

enum EffectType{
    case fade, crossFade, flash, jump
}

struct EffectsBlock: View {
    @Binding var linkedLights: [Light]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Effects")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(.horizontal, 25)
            
            Group{
                EffectsRow(linkedLights: self.$linkedLights, rowType: .fade)
                
                EffectsRow(linkedLights: self.$linkedLights, rowType: .crossFade)
                
                EffectsRow(linkedLights: self.$linkedLights, rowType: .flash)
                
                EffectsRow(linkedLights: self.$linkedLights, rowType: .jump)
            }
            .padding(.bottom, 15)
        }
    }
}

struct EffectsBlock_Previews: PreviewProvider {
    static var previews: some View {
        EffectsBlock(linkedLights: .constant([]))
    }
}
