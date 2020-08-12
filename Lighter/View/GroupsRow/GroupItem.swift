//
//  GroupItem.swift
//  Lighter
//
//  Created by Devin Green on 7/27/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GroupItem: View {
    @EnvironmentObject var manager: LightManager
    @Binding var group: LightGroup
    @Binding var linkedLights: [Light]
    
    @State var showEditHost: Bool = false
    
    var groupConnected: Bool{
        for light in self.group.lights{
            if light.status == .connected{
                return true
            }
        }
        return false
    }
    
    var groupSelected: Bool{
        return self.group.lights.sorted().elementsEqual(self.linkedLights.sorted())
    }
    
    var groupIsOn: Bool{
        var count = 0
        for light in group.lights{
            count += light.isOn ? 1 : 0
        }
        return count == group.lights.count
    }
    
    var groupState: Light.State{
        var colorCount = 0
        var effectCount = 0
        for light in group.lights{
            colorCount += light.state == .color ? 1 : 0
            effectCount += light.state == .effect ? 1 : 0
        }
        return colorCount == group.lights.count ? .color : effectCount == group.lights.count ? .effect : .neutral
    }
    
    var groupColor: UIColor?{
        var color: UIColor?
        for light in group.lights{
            if color == nil{
                color = light.color
            }else if color != light.color{
                return nil
            }
        }
        return color
    }
    
    var groupEffect: Effect.EffectValues?{
        var effect: Effect.EffectValues?
        for light in group.lights{
            if effect == nil{
                effect = light.effect
            }else if effect?.index != light.effect?.index{
                return nil
            }
        }
        return effect
    }
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                ZStack(alignment: .topTrailing){
                    BackgroundView(color: self.groupSelected ? .blue : nil)
                    
                    if self.groupIsOn && self.groupConnected{
                        Group{
                            EmptyView()
                            ColorIcon(type: groupState == .color ? .solid : self.groupEffect!.iconType, colors: groupState == .color ? [groupColor!] : self.groupEffect!.colors, shape: .circle)
                        }
                        .frame(width: 25, height: 25)
                        .padding(.trailing, -5)
                        .padding(.top, -5)
                    }
                }
                
                ZStack(alignment: .center){
                    Image(systemName: !self.groupConnected ? "lightbulb.slash" : self.groupIsOn ? "lightbulb.fill" : "lightbulb" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 40)
                    
                    Group{
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                        
                        Circle()
                            .fill(self.groupConnected ? Color.green : Color.yellow)
                    }
                    .frame(width: 15, height: 15)
                    .padding(.leading, 25)
                    .padding(.top, -25)
                }
            }
            .frame(width: 100, height: 100)
            .onTapGesture(count: 2) {
                if self.groupSelected{
                    self.linkedLights.removeAll()
                }else{
                    self.linkedLights = self.group.lights
                }
            }
            .onTapGesture(count: 1) {
                self.group.toggle()
            }
            .onLongPressGesture {
                self.showEditHost.toggle()
            }
            
            Text(group.name)
                .font(.footnote)
                .frame(height: 20)
        }
        .padding(.top, 6)
        .sheet(isPresented: self.$showEditHost) {
            GroupAddEditHost(linkedLights: self.$linkedLights, group: self.$group, name: self.group.name, selectedLights: self.group.lights, isPresented: self.$showEditHost)
                .environmentObject(self.manager)
        }
    }
}

struct GroupItem_Previews: PreviewProvider {
    static var previews: some View {
        GroupItem(group: .constant(.default), linkedLights: .constant([]))
    }
}
