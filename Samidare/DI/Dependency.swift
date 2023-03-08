//
//  Dependency.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/05.
//

import ComposableArchitecture
import Foundation

extension AppConfigRepositoryImpl: DependencyKey {
    static let liveValue: AppConfigRepositoryProtocol = AppConfigRepositoryImpl()
    static let testValue: AppConfigRepositoryProtocol = unimplemented("Do not call AppConfigRepositoryImpl in test!!")
}

extension QuestionRepositoryImpl: DependencyKey {
    static let liveValue: QuestionRepositoryProtocol = QuestionRepositoryImpl()
    static let testValue: QuestionRepositoryProtocol = unimplemented("Do not call QuestionRepositoryImpl in test!!")
}

extension DependencyValues {
    var appConfigRepository: AppConfigRepositoryProtocol {
        get { self[AppConfigRepositoryImpl.self] }
        set { self[AppConfigRepositoryImpl.self] = newValue }
    }
    var questionRepository: QuestionRepositoryProtocol {
        get { self[QuestionRepositoryImpl.self] }
        set { self[QuestionRepositoryImpl.self] = newValue }
    }
}
