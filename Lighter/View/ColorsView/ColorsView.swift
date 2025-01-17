//
//  ColorsView.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI



struct ColorsView: View {
    @EnvironmentObject var manager: LightManager
    @Binding var linkedLights: [Light]
    @State var colors : [UIColor] = [
        .red,
        .systemOrange,
        .yellow,
        .systemYellow,
        .green,
        .cyan,
        .systemTeal,
        .blue,
        .systemBlue,
        .systemPurple,
        .magenta,
        .systemPink,
        .systemRed,
        .white
    ]
    
    func itemForCoordinates(x: Int, y: Int) -> some View{
        let index = (y * 6) + x
        
        var showIndication: Bool{
            if index < self.colors.count{
                var count = 0
                for light in linkedLights{
                    if let components = light.color?.components, components == self.colors[index].components, light.state == .color{
                        count += 1
                    }
                }
                return linkedLights.count != 0 && linkedLights.count == count
            }
            return false
        }
        
        return Group{
            if index < self.colors.count{
                ZStack{
                    ColorIcon(type: .solid, colors: [self.colors[index]], shape: .rectangle)
                        .onTapGesture {
                            for x in self.linkedLights.indices{
                                self.linkedLights[x].setColor(color: self.colors[index])
                            }
                    }
                    
                    if showIndication{
                        Circle()
                            .fill(Color.white)
                            .padding(15)
                            .shadow(radius: 10)
                    }
                }
            }else{
                ColorIcon(type: .solid, colors: [.clear], shape: .rectangle)
            }
        }
        .aspectRatio(1, contentMode: .fill)
    }
    
    var body: some View {
        let columnCount = (self.colors.count / 6) + (self.colors.count % 6 == 0 ? 0 : 1)
        
        return VStack(alignment: .leading){
            Text("Colors")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
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

struct ColorsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsView(linkedLights: .constant([]))
    }
}
