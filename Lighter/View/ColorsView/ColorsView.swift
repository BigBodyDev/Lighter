//
//  ColorsView.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI



struct ColorsView: View {
    @State var colors : [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink
    ]
    
    func itemForCoordinates(x: Int, y: Int) -> some View{
        let index = (y * 6) + x
        
        return Group{
            if index < self.colors.count{
                BackgroundView(color: self.colors[index])
                    .onTapGesture {
                        print("color selected")
                }
            }else{
                BackgroundView(color: .clear)
            }
        }
        .aspectRatio(1, contentMode: .fill)
    }
    
    var body: some View {
        let columnCount = (self.colors.count / 6) + (self.colors.count % 6 == 0 ? 0 : 1)
        
        return VStack(alignment: .leading){
            Text("Colors")
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

struct ColorsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsView()
    }
}
