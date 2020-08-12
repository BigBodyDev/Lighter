//
//  BackgroundView.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    var color: Color?
    var gradientColors: [Color]?
    
    var body: some View {
        Group{
            if gradientColors == nil{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(color != nil ? color : colorScheme == .dark ? Color.white.opacity(0.1) : .white)
            }else{
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(gradient: Gradient(colors: gradientColors!), startPoint: .bottomLeading, endPoint: .topTrailing))
            }
        }
        .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 10)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
