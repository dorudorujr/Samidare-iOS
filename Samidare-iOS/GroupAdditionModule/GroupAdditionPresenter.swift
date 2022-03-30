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
    
    @Published var groups: [QuestionGroup]?
    @Published var error: Error?
    
    init(interactor: GroupAdditionInteractor) {
        self.interactor = interactor
        groups = interactor.getQuestionGroup()
    }
    
    func add(_ questionGroup: QuestionGroup) {
        do {
            try interactor.add(questionGroup)
            groups = interactor.getQuestionGroup()
        } catch {
            self.error = error
        }
    }
}
