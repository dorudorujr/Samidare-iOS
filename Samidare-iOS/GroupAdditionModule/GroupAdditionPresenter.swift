//
//  GroupAdditionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import Combine
import SwiftUI

@MainActor
class GroupAdditionPresenter<Repository: QuestionGroupRepositoryProtocol>: ObservableObject {
    private let interactor: GroupAdditionInteractor<Repository>
    private let router: GroupAdditionRouter
    
    @Published var isShowingAddAlert = false
    @Published var alertText = ""
    @Published var groups: [QuestionGroup]?
    @Published var error: Error?
    
    init(interactor: GroupAdditionInteractor<Repository>, router: GroupAdditionRouter) {
        self.interactor = interactor
        self.router = router
        groups = interactor.getQuestionGroup()
    }
    
    func addQuestionGroup() {
        do {
            let questionGroup = QuestionGroup(name: alertText)
            try interactor.add(questionGroup)
            groups = interactor.getQuestionGroup()
        } catch {
            self.error = error
        }
    }
    
    func didTapNavBarButton() {
        isShowingAddAlert = true
    }

    func deleteGroup(on index: IndexSet) {
        guard let group = groups?[safe: index.first ?? 0] else { return }
        groups?.remove(atOffsets: index)
        do {
            try interactor.delete(group)
        } catch {
            self.error = error
        }
    }
    
    func questionAdditionLinkBuilder<Content: View>(group: QuestionGroup,
                                                    @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeQuestionAdditionView(group: group)) {
            content()
        }
    }
}
