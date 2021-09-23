//
//  ActivityIndicator.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 1/09/21.
//  Base https://github.com/MojtabaHs/iActivityIndicator
//

import SwiftUI

struct ActivityIndicator: View {
    
    @Binding private var isAnimating: Bool
    let count: UInt
    let width: CGFloat
    public let spacing: CGFloat
    
    init(show: Binding<Bool>, count: UInt = 3, width: CGFloat = 8, spacing: CGFloat = 1) {
        self._isAnimating = show
        self.count = count
        self.width = width
        self.spacing = spacing
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(count)) { index in
                item(forIndex: index, in: geometry.size)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .animation(
                        Animation.default
                            .speed(Double.random(in: 0.2...0.5))
                            .repeatCount(isAnimating ? .max : 1, autoreverses: false)
                    )
            }
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.green)
        .opacity(isAnimating ? 1 : 0)
       
    }
    
    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        Group { () -> Path in
            var p = Path()
            p.addArc(center: CGPoint(x: geometrySize.width/2, y: geometrySize.height/2),
                     radius: geometrySize.width/2 - width/2 - CGFloat(index) * (width + spacing),
                     startAngle: .degrees(0),
                     endAngle: .degrees(Double(Int.random(in: 120...300))),
                     clockwise: true)
            return p.strokedPath(.init(lineWidth: width))
        }
        .frame(width: geometrySize.width, height: geometrySize.height)
    }
    
}

struct ActivityIndicator_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        ActivityIndicator(show: $show)
    }
}
