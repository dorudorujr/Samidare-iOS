//
//  QuestionCardView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/15.
//

import SwiftUI

struct QuestionCardView: View {
    let questionBody: String
    let gradationTop: Color
    let gradationBottom: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                .linearGradient(colors: [
                    gradationTop,
                    gradationBottom
                ], startPoint: .top, endPoint: .bottom)
            )
            .padding(.top)
        
        VStack() {
            Text(questionBody)
                .font(.system(size: 30))
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCardView(questionBody: "好きな色は", gradationTop: Color.gradationTopBlue, gradationBottom: Color.gradationBottomBlue)
    }
}
