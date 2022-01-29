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
    let color: Color
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .frame(width: 50, height: 50)
                .font(.system(size: 16))
                .padding()
                .background(color)
                .clipShape(Circle())
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(5)
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 3)
                )
        })
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(action: {}, title: "Title", color: Color.bassBlue)
    }
}
