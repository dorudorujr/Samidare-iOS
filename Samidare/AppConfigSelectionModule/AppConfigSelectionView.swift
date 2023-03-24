//
//  AppConfigSelectionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import SwiftUI
import ComposableArchitecture

struct AppConfigSelectionView: View {
    let store: StoreOf<AppConfigSelectionReducer>
    private let description: String
    
    init(store: StoreOf<AppConfigSelectionReducer>, description: String) {
        self.store = store
        self.description = description
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if let questionGroups = viewStore.state.questionGroups {
                    QuestionGroupSelectionList(questionGroups: questionGroups,
                                               description: description,
                                               selectQuestionGroupName: viewStore.state.selectQuestionGroupName,
                                               tapGesture: { group in viewStore.send(.updateQuestionGroup(questionGroup: group)) })
                }
                if let appConfigGameTime = viewStore.state.appConfigGameTime {
                    GameTimeList(appConfigGameTime: appConfigGameTime,
                                 description: description,
                                 tapGesture: { gameTime in viewStore.send(.updateGameTime(gameTime: gameTime)) })
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle(L10n.App.Config.Selection.Question.Group.title)
            .navigationBarTitleDisplayMode(.inline)
            .alert(self.store.scope(state: \.errorAlert),
                   dismiss: .alertDismissed)
        }
    }
}

struct AppConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigSelectionView(store: .init(initialState: AppConfigSelectionReducer.State(type: .questionGroup),
                                            reducer: AppConfigSelectionReducer()),
                               description: "AppConfigSelectionView")
    }
}
