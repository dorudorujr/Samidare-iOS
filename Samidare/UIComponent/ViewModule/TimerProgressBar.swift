//
//  TimerProgressBar.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/10.
//

import SwiftUI

struct TimerProgressBar: View {
    let duration: CGFloat
    let gradationTop: Color
    let gradationBottom: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.whitesmoke)
                    .frame(width: geometry.frame(in: .global).width, height: 15)
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        .linearGradient(colors: [
                            gradationTop,
                            gradationBottom
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: geometry.frame(in: .global).width * duration, height: 15)
            }
        }
    }
}

struct TimerProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        TimerProgressBar(duration: 1.0, gradationTop: Color.gradationTopBlue, gradationBottom: Color.gradationBottomBlue)
    }
}
