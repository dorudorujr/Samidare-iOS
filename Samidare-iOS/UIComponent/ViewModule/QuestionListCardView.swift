//
//  QuestionListCardView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/02.
//

import SwiftUI

struct QuestionListCardView: View {
    let questionBody: String
    var body: some View {
        Capsule()
            .inset(by: 10)
            .stroke(Color.textBlack, lineWidth: 2)
            .overlay(
                Text(questionBody)
                    .foregroundColor(.textBlack)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
            )
    }
}

struct QuestionListCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListCardView(questionBody: "好きな色は")
    }
}
