//
//  SpeedBrightnessView.swift
//  Lighter
//
//  Created by Devin Green on 8/12/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct SpeedBrightnessView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.blue)
            .frame(width: 50, height: 225)
    }
}

struct SpeedBrightnessView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedBrightnessView()
    }
}
