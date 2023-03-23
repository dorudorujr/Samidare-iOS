//
//  QuestionAdditionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import SwiftUI
import ComposableArchitecture

struct QuestionAdditionView: View {
    let store: StoreOf<QuestionAdditionReducer>
    
    // swiftlint:disable closure_body_length
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                TextFieldAlertView(text: viewStore.binding(\.$addQuestionBody),
                                   isShowingAlert: viewStore.binding(\.$isShowingAddAlert),
                                   placeholder: "",
                                   isSecureTextEntry: false,
                                   title: L10n.Question.Addition.Alert.title,
                                   message: L10n.Question.Addition.Alert.message,
                                   leftButtonTitle: L10n.Common.cancel,
                                   rightButtonTitle: L10n.Common.add,
                                   leftButtonAction: nil,
                                   rightButtonAction: { viewStore.send(.addQuestion) })
                TextFieldAlertView(text: viewStore.binding(\.$updateQuestionBody),
                                   isShowingAlert: viewStore.binding(\.$isShowingUpdateAlert),
                                   placeholder: "",
                                   isSecureTextEntry: false,
                                   title: L10n.Question.Addition.Alert.title,
                                   message: L10n.Question.Addition.Alert.message,
                                   leftButtonTitle: L10n.Common.cancel,
                                   rightButtonTitle: L10n.Common.add,
                                   leftButtonAction: nil,
                                   rightButtonAction: { viewStore.send(.update) })
                List {
                    ForEach(viewStore.questions) { question in
                        QuestionListCardView(questionBody: question.body)
                            .onTapGesture {
                                viewStore.send(.didTapList(question: question))
                            }
                    }
                    .onDelete(perform: { indexSet in
                        viewStore.send(.delete(index: indexSet))
                    })
                }
                .navigationTitle(viewStore.questionGroup.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.didTapNavBarButton) }, label: {
                            Image(systemName: "plus")
                                .renderingMode(.template)
                                .foregroundColor(.blue)
                        })
                    }
                }
                .alert(self.store.scope(state: \.errorAlert),
                       dismiss: .alertDismissed)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct QuestionAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAdditionView(store: .init(initialState: QuestionAdditionReducer.State(questionGroup: .init(name: "デフォルト")), reducer: QuestionAdditionReducer()))
    }
}
