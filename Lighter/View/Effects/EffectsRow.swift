//
//  EffectsRow.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct EffectsRow: View {
    var body: some View {
        ZStack(alignment: .leading){
            BackgroundView(gradientColors: [.red, .blue])
            
            Text("Lighting Effects")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .padding(25)
        }
    }
}

struct EffectsRow_Previews: PreviewProvider {
    static var previews: some View {
        EffectsRow()
    }
}
