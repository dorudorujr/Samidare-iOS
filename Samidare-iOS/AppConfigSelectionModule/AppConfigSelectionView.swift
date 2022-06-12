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
                    ForEach(self.presenter.questionGroups) { group in
                        ListRow(title: group.name, isSelected: presenter.isSelectedQuestionGroup(questionGroup: group))
                            .onTapGesture {
                                presenter.update(group.name)
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
        AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init()), description: "AppConfigSelectionView")
    }
}
