//
//  GroupAdditionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import Combine
import SwiftUI

@MainActor
class GroupAdditionPresenter: ObservableObject {
    private let interactor: GroupAdditionInteractor
    
    @Published var isShowingAddAlert = false
    @Published var alertText = ""
    @Published var groups: [QuestionGroup]?
    @Published var error: Error?
    
    init(interactor: GroupAdditionInteractor) {
        self.interactor = interactor
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
        groups?.remove(atOffsets: index)
        guard let group = groups?[safe: index.first ?? 0] else { return }
        do {
            try interactor.delete(group)
        } catch {
            self.error = error
        }
    }
}
