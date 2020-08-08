//
//  GroupItem.swift
//  Lighter
//
//  Created by Devin Green on 7/27/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GroupItem: View {
    @Binding var group: LightGroup
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                BackgroundView()
                
                ZStack(alignment: .center){
                    Image(systemName: "lightbulb.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(30)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 15, height: 15)
                        .padding(.leading, 25)
                        .padding(.top, -25)
                }
                
            }
            .frame(width: 100, height: 100)
            
            Text(group.name)
                .font(.footnote)
                .frame(height: 20)
        }
    }
}

struct GroupItem_Previews: PreviewProvider {
    static var previews: some View {
        GroupItem(group: .constant(.default))
    }
}
