//
//  TimerProgressBar.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/10.
//

import SwiftUI

struct TimerProgressBar: View {
    let duration: Binding<CGFloat>
    let color: Color
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(Color.whitesmoke, style: StrokeStyle(lineWidth: 10))
                .scaledToFit()
            Circle()
                .trim(from: 0.0, to: duration.wrappedValue)
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .scaledToFit()
                .rotationEffect(.degrees(-90))
        }
    }
}

struct TimerProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        TimerProgressBar(duration: .constant(1.0), color: .bassBlue)
    }
}
