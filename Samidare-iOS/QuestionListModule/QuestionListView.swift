//
//  QuestionListView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/05.
//

import SwiftUI

struct QuestionListView: View {
    @Environment(\.dismiss) var dismiss
    private let presenter: QuestionListPresenter
    
    init(presenter: QuestionListPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            List {
                if let questions = presenter.questions {
                    ForEach(questions) { question in
                        QuestionListCardView(questionBody: question.body)
                    }
                }
            }
            .navigationTitle(L10n.Question.List.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "multiply")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                    })
                }
            }
        }
    }
}

struct QuestionListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListView(presenter: .init(interactor: .init(), group: "デフォルト"))
    }
}
