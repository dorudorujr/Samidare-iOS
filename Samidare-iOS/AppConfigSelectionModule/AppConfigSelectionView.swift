//
//  AppConfigSelectionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import SwiftUI

struct AppConfigSelectionView<AppConfigRepository: AppConfigRepositoryProtocol, GroupRepository: QuestionGroupRepositoryProtocol>: View {
    @ObservedObject private var presenter: AppConfigSelectionPresenter<AppConfigRepository, GroupRepository>
    
    init(presenter: AppConfigSelectionPresenter<AppConfigRepository, GroupRepository>) {
        self.presenter = presenter
    }
    
    var body: some View {
        List {
            Section {
                ForEach(self.presenter.questionGroups) { group in
                    ListRow(title: group.name, isSelected: presenter.isSelectedQuestionGroup(questionGroup: group))
                        .onTapGesture {
                            presenter.update(group.name)
                        }
                }
            }
        }
        .onAppear {
            presenter.fetchQuestionGroups()
        }
        .navigationTitle(L10n.App.Config.Selection.Question.Group.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init()))
    }
}
