//
//  QuestionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Foundation

class QuestionInteractor<QuestionRepository: QuestionRepositoryProtocol, AppConfigRepository: AppConfigRepositoryProtocol> {
    
    private func questions() -> [Question] {
        let group = AppConfigRepository.get().questionGroupName
        return QuestionRepository.getQuestions(of: group)
    }
    
    /*
     parameters:    次の質問を取得したい質問。
     return:        次の質問。※parametersがnilの時は最初の質問を返す
     */
    func nextQuestion(for question: Question) -> Question? {
        let questions = questions()
        guard let questionOfIndex = getIndex(of: question) else {
            return questions.first
        }
        return questions[safe: questionOfIndex + 1]
    }
    
    func firstQuestion() -> Question? {
        questions().first
    }
    
    func lastQuestion() -> Question? {
        questions().last
    }
    
    func shouldShowQuestion(question: Question?) -> Bool {
        question != nil
    }
    
    func getIndex(of question: Question) -> Int? {
        questions().firstIndex(of: question)
    }
    
    func getTotalQuestionCount() -> Int {
        let group = AppConfigRepository.get().questionGroupName
        return QuestionRepository.getQuestions(of: group).count
    }

    func getTime() -> Int {
        return AppConfigRepository.get().time
    }
    
    func questionGroup() -> String {
        AppConfigRepository.get().questionGroupName
    }
}
