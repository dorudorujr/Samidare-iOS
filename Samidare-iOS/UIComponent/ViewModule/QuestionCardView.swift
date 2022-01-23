//
//  QuestionCardView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/15.
//

import SwiftUI

struct QuestionCardView: View {
    let questionBody: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(lineWidth: 2)
                .fill(Color.textBlack)
                .scaleEffect(x: 0.7, y: 0.6, anchor: .center)
            Text(questionBody)
                .foregroundColor(.textBlack)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
        }
    }
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCardView(questionBody: "好きな色は")
    }
}
