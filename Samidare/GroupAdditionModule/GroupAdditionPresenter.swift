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
    enum ErrorType {
        case questionGroupUniqueError
        case commonError
        
        var title: String {
            switch self {
            case .questionGroupUniqueError:
                return ""
            case .commonError:
                return L10n.Error.title
            }
        }
        var message: String {
            switch self {
            case .questionGroupUniqueError:
                return L10n.Error.Question.Group.unique
            case .commonError:
                return L10n.Error.message
            }
        }
    }
    
    private let interactor: GroupAdditionInteractor<Repository>
    private let router: GroupAdditionRouter
    
    private var editQuestionGroup: QuestionGroup?
    
    private(set) var errorType: ErrorType = .commonError
    
    @Published private(set) var groups: [QuestionGroup]?
    @Published var isShowingAddAlert = false
    @Published var isShowingEditAlert = false
    @Published var isShowingErrorAlert = false
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
            errorType = .questionGroupUniqueError
        } else {
            errorType = .commonError
            Log.fault(error, className: String(describing: type(of: self)), functionName: #function)
        }
        isShowingErrorAlert = true
    }
}
