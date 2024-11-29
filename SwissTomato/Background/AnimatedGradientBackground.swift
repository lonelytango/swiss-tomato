//
//  AnimatedGradientBackground.swift
//  SwissTomato
//
//  Created by Zian Chen on 11/27/24.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 1, y: 1)
    
    let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
    let colors: [Color]
    
    init(colors: [Color] = [
        Color(red: 0.984, green: 0.929, blue: 0.847),
        Color(red: 0.988, green: 0.894, blue: 0.839),
        Color(red: 0.992, green: 0.859, blue: 0.831)
    ]) {
        self.colors = colors
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 5)) {
                    self.start = UnitPoint(x: Double.random(in: 0...1),
                                         y: Double.random(in: 0...1))
                    self.end = UnitPoint(x: Double.random(in: 0...1),
                                       y: Double.random(in: 0...1))
                }
            }
            .ignoresSafeArea()
    }
}
