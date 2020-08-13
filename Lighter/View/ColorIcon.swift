//
//  ColorIcon.swift
//  Lighter
//
//  Created by Devin Green on 8/11/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

enum ColorIconShape: Int{
    case circle = 0
    case rectangle = 1
}

enum ColorIconType: Int{
    case solid = 0
    case twoSolid = 1
    case twoGradient = 2
    case wheelSolid = 3
    case wheelGradient = 4
    case slices = 5
}

struct ColorIcon: View {
    var type: ColorIconType
    var colors: [UIColor]
    var shape: ColorIconShape
    
    var icon: some View{
        ZStack{
            if self.type == .solid{
                Rectangle()
                    .foregroundColor(Color(colors[0].color(withBrightness: 1)))
            }else if self.type == .twoSolid{
                Rectangle()
                    .foregroundColor(Color(colors[0].color(withBrightness: 1)))
                    .mask(Triangle(point1: .topLeft, point2: .bottomLeft, point3: .topRight))

                Rectangle()
                    .foregroundColor(Color(colors[1].color(withBrightness: 1)))
                    .mask(Triangle(point1: .bottomLeft, point2: .topRight, point3: .bottomRight))

            }else if self.type == .twoGradient{
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(self.colors[0].color(withBrightness: 1)), Color(self.colors[1].color(withBrightness: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
            }else if self.type == .wheelSolid{
                Wheel(colors: self.colors.map({ Color($0.color(withBrightness: 1)) }))
                .mask(Rectangle())

            }else if self.type == .wheelGradient{
                Rectangle()
                    .fill(AngularGradient(gradient: Gradient(colors: self.colors.map( { Color($0.color(withBrightness: 1)) } )), center: .center))
                
            }else if self.type == .slices{
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: colors.map( { Color($0.color(withBrightness: 1)) } )), startPoint: .bottomLeading, endPoint: .topTrailing))
                    .mask(Triangle(point1: .topLeft, point2: .bottomLeft, point3: .topRight))
                
                Rectangle()
                    .foregroundColor(Color(white: 0.1))
                    .mask(Triangle(point1: .bottomLeft, point2: .topRight, point3: .bottomRight))
            }
        }
    }
    
    var body: some View {
        ZStack{
            if self.shape == .rectangle{
                icon
                    .mask(RoundedRectangle(cornerRadius: 15))
            }else if self.shape == .circle{
                Circle()
                    .stroke(Color.white, lineWidth: 5)
                
                icon
                    .mask(Circle())
            }
        }
    }
}

struct ColorIcon_Previews: PreviewProvider {
    static var previews: some View {
        ColorIcon(type: .solid, colors: [.red], shape: .rectangle)
    }
}

enum TrianglePoint {
    case topLeft, topCenter, topRight, centerLeft, center, centerRight, bottomLeft, bottomCenter, bottomRight
}

public struct Triangle: Shape {
    var point1: TrianglePoint
    var point2: TrianglePoint
    var point3: TrianglePoint
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        func pointFromPoint(_ trianglePoint: TrianglePoint) -> CGPoint{
            switch trianglePoint {
            case .topLeft:
                return CGPoint(x: rect.origin.x, y: rect.origin.y)
            case .topCenter:
                return CGPoint(x: rect.width / 2, y: rect.origin.y)
            case .topRight:
                return CGPoint(x: rect.width, y: rect.origin.y)
            case .centerLeft:
                return CGPoint(x: rect.origin.x, y: rect.height / 2)
            case .center:
                return CGPoint(x: rect.width / 2, y: rect.height / 2)
            case .centerRight:
                return CGPoint(x: rect.width, y: rect.height / 2)
            case .bottomLeft:
                return CGPoint(x: rect.origin.x, y: rect.height)
            case .bottomCenter:
                return CGPoint(x: rect.width / 2, y: rect.height)
            case .bottomRight:
                return CGPoint(x: rect.width, y: rect.height)
            }
        }
        
        path.move(to: pointFromPoint(self.point1))
        path.addLine(to: pointFromPoint(self.point2))
        path.addLine(to: pointFromPoint(self.point3))
        path.closeSubpath()
        return path
    }
    
}

struct Wheel: View {
    var colors: [Color]
    
    func wheelPieces(forIndex index: Int, inDataSet dataSet: [WheelPieceData]) -> some View{
        Group {
            WheelPiece(radius: 40, lineWidth: 50, data: (index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)))
                .fill((index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)).color)
            
            WheelPiece(radius: 15, lineWidth: 25, data: (index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)))
                .fill((index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)).color)
            
            WheelPiece(radius: 3, lineWidth: 5, data: (index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)))
                .fill((index < dataSet.count ? dataSet[index] : WheelPieceData(startAngle: 0, arcAngle: 0, color: .white)).color)
        }
    }
    
    var body: some View {
        var startAngle: Double = 90
        
        var dataSet = [WheelPieceData]()
        for color in colors{
            
            let percentage: Double = 1.0 / Double(colors.count)
            let arcAngle = percentage * 360
            
            let data = WheelPieceData(startAngle: startAngle, arcAngle: arcAngle, color: color)
            
            startAngle += arcAngle
            while startAngle >= 360{
                startAngle -= 360
            }
            
            dataSet.append(data)
        }
        
        return ForEach(0..<dataSet.count, id: \.self) { index in
            self.wheelPieces(forIndex: index, inDataSet: dataSet)
            }
        }
}

struct WheelPiece: Shape {
    var radius: CGFloat
    var lineWidth: CGFloat
    var data: WheelPieceData

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(data.startAngle), endAngle: .degrees(data.startAngle + data.arcAngle), clockwise: false)
        return path.strokedPath(.init(lineWidth: lineWidth))
    }
}

struct WheelPieceData: Hashable {
    var startAngle: Double
    var arcAngle: Double
    var color: Color
}
