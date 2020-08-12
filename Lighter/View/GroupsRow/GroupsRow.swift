//
//  GroupsRow.swift
//  Lighter
//
//  Created by Devin Green on 7/26/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GroupsRow: View {
    @EnvironmentObject var manager: LightManager
    @Binding var linkedLights: [Light]
    
    @State var selectedGroup: LightGroup = .default
    @State var showAddEditHost: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Groups")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(.horizontal, 25)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(self.manager.groups.indices, id: \.self) { index in
                        GroupItem(group: self.$manager.groups[index], linkedLights: self.$linkedLights)
                            .padding(.leading, index == 0 ? 20 : 0)
                            .padding(.trailing, index == self.manager.groups.count - 1 ? 20 : 0)
                            .onLongPressGesture {
                                self.selectedGroup = self.manager.groups[index]
                                self.showAddEditHost.toggle()
                        }
                    }
                    
                    Button(action: {
                        self.selectedGroup = .default
                        self.showAddEditHost.toggle()
                    }) {
                        ZStack{
                            BackgroundView(color: .blue)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15)
                        }
                        .frame(width: 35, height: self.manager.groups.count == 0 ? 135 : 100)
                        .padding(.leading, self.manager.groups.count == 0 ? 20 : -20)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 6)
                }
                .frame(height: 135)
            }
        }
        .sheet(isPresented: self.$showAddEditHost) {
            GroupAddEditHost(linkedLights: self.$linkedLights, group: self.$selectedGroup, name: self.selectedGroup.name, selectedLights: self.selectedGroup.lights, isPresented: self.$showAddEditHost)
                .environmentObject(self.manager)
        }
    }
}

struct GroupsRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupsRow(linkedLights: .constant([]))
    }
}
