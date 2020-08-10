//
//  GroupsRow.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GroupsRow: View {
    @Binding var groups: [LightGroup]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Light Groups")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(.horizontal, 25)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(self.groups.indices, id: \.self) { index in
                        GroupItem(group: self.$groups[index])
                            .padding(.leading, index == 0 ? 20 : 0)
                            .padding(.trailing, index == self.groups.count - 1 ? 20 : 0)
                    }
                    
                    Button(action: {
                        print("Add group")
                    }) {
                        ZStack{
                            BackgroundView(color: .blue)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15)
                        }
                        .frame(width: 50, height: 125)
                        .padding(.leading, self.groups.count == 0 ? 20 : 0)
                        .padding(.trailing, 20)
                    }
                }
                .frame(height: 125)
            }
        }
    }
}

struct GroupsRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupsRow(groups: .constant([.default, .default]))
    }
}
