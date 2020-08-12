//
//  LightOptionRow.swift
//  Lighter
//
//  Created by Devin Green on 8/11/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct LightOptionRow: View {
    @Binding var selectedLights: [Light]
    @Binding var light: Light
    
    var body: some View {
        Button(action: {
            if let index = self.selectedLights.firstIndex(of: self.light){
                self.selectedLights.remove(at: index)
            }else{
                self.selectedLights.append(self.light)
            }
        }) {
            HStack{
                Text(light.registeredName)
                
                Spacer()
                
                Image(systemName: selectedLights.contains(light) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(selectedLights.contains(light) ? .blue : .white)
                    .frame(width: 30, height: 30)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        
    }
}

struct LightOptionRow_Previews: PreviewProvider {
    static var previews: some View {
        LightOptionRow(selectedLights: .constant([]), light: .constant(.default))
    }
}
