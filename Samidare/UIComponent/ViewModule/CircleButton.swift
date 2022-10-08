//
//  PrimaryButton.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/10.
//

import SwiftUI

struct CircleButton: View {
    let action: () -> Void
    let title: String
    let gradationTop: Color
    let gradationBottom: Color
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .frame(width: 50, height: 50)
                .padding()
                .background(
                    .linearGradient(colors: [gradationTop, gradationBottom], startPoint: .top, endPoint: .bottom)
                )
                .clipShape(Circle())
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(5)
                .overlay(
                    Circle()
                        .stroke(.linearGradient(colors: [gradationTop, gradationBottom], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                )
        })
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(action: {}, title: "Title", gradationTop: Color.gradationTopBlue, gradationBottom: Color.gradationBottomBlue)
    }
}
