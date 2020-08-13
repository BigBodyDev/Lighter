//
//  SBSlider.swift
//  Lighter
//
//  Created by Devin Green on 8/12/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct SBSlider: View {
    
    @Binding var percentage: Double
    var minPercentage: Double
    var maxPercentage: Double
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(Color(white: 0.1))
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(height: geometry.size.height * CGFloat(self.percentage / 100))
            }
            .mask(RoundedRectangle(cornerRadius: 15))
            .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                let newPercentage = min(max(self.minPercentage, Double((1 - (value.location.y / geometry.size.height)) * 100)), self.maxPercentage)
                if self.percentage != newPercentage{
                    self.percentage = newPercentage
                }
            }))
        }
    }
}

struct SBSlider_Previews: PreviewProvider {
    static var previews: some View {
        SBSlider(percentage: .constant(50), minPercentage: 0, maxPercentage: 100)
    }
}
