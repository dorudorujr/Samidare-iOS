//
//  QuestionAdditionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import SwiftUI

struct QuestionAdditionView: View {
    @ObservedObject private var presenter: QuestionAdditionPresenter
    
    init(presenter: QuestionAdditionPresenter) {
        self.presenter = presenter
    }
    
    // swiftlint:disable closure_body_length
    var body: some View {
        ZStack {
            TextFieldAlertView(text: $presenter.addQuestionBody,
                               isShowingAlert: $presenter.isShowingAddAlert,
                               placeholder: "",
                               isSecureTextEntry: false,
                               title: L10n.Question.Addition.Alert.title,
                               message: L10n.Question.Addition.Alert.message,
                               leftButtonTitle: L10n.Common.cancel,
                               rightButtonTitle: L10n.Common.add,
                               leftButtonAction: nil,
                               rightButtonAction: { presenter.addQuestion() })
            TextFieldAlertView(text: $presenter.updateQuestionBody,
                               isShowingAlert: $presenter.isShowingUpdateAlert,
                               placeholder: "",
                               isSecureTextEntry: false,
                               title: L10n.Question.Addition.Alert.title,
                               message: L10n.Question.Addition.Alert.message,
                               leftButtonTitle: L10n.Common.cancel,
                               rightButtonTitle: L10n.Common.add,
                               leftButtonAction: nil,
                               rightButtonAction: { presenter.updateQuestion() })
            List {
                if let questions = self.presenter.questions {
                    ForEach(questions) { question in
                        QuestionListCardView(questionBody: question.body)
                            .onTapGesture {
                                presenter.didTapList(question: question)
                            }
                    }
                    .onDelete(perform: { indexSet in
                        presenter.deleteQuestion(on: indexSet)
                    })
                }
            }
            .navigationTitle(L10n.Question.Addition.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { presenter.didTapNavBarButton() }, label: {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                    })
                }
            }
        }
    }
}

struct QuestionAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAdditionView(presenter: .init(interactor: .init(), group: "デフォルト"))
    }
}