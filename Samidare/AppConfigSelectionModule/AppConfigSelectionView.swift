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
                List {
                    Section {
                        if let questionGroups = viewStore.state.questionGroups {
                            ForEach(questionGroups) { group in
                                ListRow(title: group.name, isSelected: viewStore.state.selectQuestionGroupName == group.name)
                                    .onTapGesture {
                                        viewStore.send(.updateQuestionGroup(questionGroup: group))
                                    }
                            }
                        }
                        if let appConfigGameTime = viewStore.state.appConfigGameTime {
                            ForEach(GameTime.allCases) { gameTime in
                                ListRow(title: gameTime.rawValue.description, isSelected: appConfigGameTime == gameTime.rawValue)
                                    .onTapGesture {
                                        viewStore.send(.updateGameTime(gameTime: gameTime.rawValue))
                                    }
                            }
                        }
                    } header: {
                        Text(description)
                            .foregroundColor(.textBlack)
                            .font(.system(size: 15))
                            .padding(.bottom, 10)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
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
