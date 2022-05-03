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
        Text(questionBody)
            .foregroundColor(.textBlack)
            .font(.system(size: 15))
            .fontWeight(.bold)
            .padding()
    }
}

struct QuestionListCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListCardView(questionBody: "好きな色は")
    }
}
