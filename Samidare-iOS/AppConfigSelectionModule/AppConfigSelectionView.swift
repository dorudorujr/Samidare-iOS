//
//  AppConfigSelectionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import SwiftUI

struct AppConfigSelectionView<AppConfigRepository: AppConfigRepositoryProtocol, GroupRepository: QuestionGroupRepositoryProtocol>: View {
    @ObservedObject private var presenter: AppConfigSelectionPresenter<AppConfigRepository, GroupRepository>
    private let description: String
    
    init(presenter: AppConfigSelectionPresenter<AppConfigRepository, GroupRepository>,
         description: String) {
        self.presenter = presenter
        self.description = description
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    if let questionGroups = self.presenter.questionGroups {
                        ForEach(questionGroups) { group in
                            ListRow(title: group.name, isSelected: presenter.isSelectedQuestionGroup(questionGroup: group))
                                .onTapGesture {
                                    presenter.update(questionGroup: group)
                                }
                        }
                    }
                    if let appConfigGameTime = presenter.appConfigGameTime {
                        ForEach(GameTime.allCases) { gameTime in
                            ListRow(title: gameTime.rawValue.description, isSelected: appConfigGameTime == gameTime.rawValue)
                                .onTapGesture {
                                    presenter.update(gameTime: gameTime.rawValue)
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
                presenter.fetchQuestionGroups()
            }
        }
        .navigationTitle(L10n.App.Config.Selection.Question.Group.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), type: .questionGroup), description: "AppConfigSelectionView")
    }
}
