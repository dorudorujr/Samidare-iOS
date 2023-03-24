//
//  QuestionGroupSelectionList.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/24.
//

import SwiftUI

struct QuestionGroupSelectionList: View {
    let questionGroups: [QuestionGroup]
    let description: String
    let selectQuestionGroupName: String
    let tapGesture: (QuestionGroup) -> Void
    var body: some View {
        List {
            Section {
                ForEach(questionGroups) { group in
                    ListRow(title: group.name, isSelected: selectQuestionGroupName == group.name)
                        .onTapGesture {
                            tapGesture(group)
                        }
                }
            } header: {
                Text(description)
                    .foregroundColor(.textBlack)
                    .font(.system(size: 15))
                    .padding(.bottom, 10)
            }
        }
    }
}

struct QuestionGroupSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionGroupSelectionList(questionGroups: [.init(name: "QuestionGroup")], description: "QuestionGroupSelectionList", selectQuestionGroupName: "QuestionGroup", tapGesture: { _ in })
    }
}
