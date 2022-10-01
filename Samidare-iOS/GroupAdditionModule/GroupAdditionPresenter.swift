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
    
    private var editQuestionGroup: QuestionGroup?
    
    @Published private(set) var groups: [QuestionGroup]?
    @Published var isShowingAddAlert = false
    @Published var isShowingEditAlert = false
    @Published var isShowingQuestionGroupUniqueErrorAlert = false
    @Published var addAlertText = ""
    @Published var editAlertText = ""
    
    init(interactor: GroupAdditionInteractor<Repository>, router: GroupAdditionRouter) {
        self.interactor = interactor
        self.router = router
        groups = interactor.getQuestionGroup()
    }
    
    func addQuestionGroup() {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .addQuestionGroup)
        do {
            let questionGroup = QuestionGroup(name: addAlertText)
            try interactor.add(questionGroup)
            groups = interactor.getQuestionGroup()
        } catch {
            errorHandling(error: error)
        }
    }
    
    func editQuestionGroupName() {
        guard let editQuestionGroup = editQuestionGroup else {
            return
        }
        FirebaseAnalyticsConfig.sendEventLog(eventType: .editQuestionGroupName)
        do {
            try interactor.add(.init(id: editQuestionGroup.id, name: editAlertText))
            groups = interactor.getQuestionGroup()
        } catch {
            errorHandling(error: error)
        }
    }
    
    func didTapNavBarButton() {
        isShowingAddAlert = true
    }
    
    func didTapEditSwipeAction(editQuestionGroup: QuestionGroup) {
        self.editQuestionGroup = editQuestionGroup
        editAlertText = self.editQuestionGroup?.name ?? ""
        isShowingEditAlert = true
    }

    func delete(_ group: QuestionGroup) {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .deleteQuestionGroup)
        do {
            try interactor.delete(group)
            groups = interactor.getQuestionGroup()
        } catch {
            errorHandling(error: error)
        }
    }
    
    func questionAdditionLinkBuilder<Content: View>(group: QuestionGroup,
                                                    @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeQuestionAdditionView(group: group)) {
            content()
        }
    }
    
    private func errorHandling(error: Error) {
        if error as? QuestionGroupUniqueError != nil {
            isShowingQuestionGroupUniqueErrorAlert = true
        } else {
            Log.fault(error)
        }
    }
}
