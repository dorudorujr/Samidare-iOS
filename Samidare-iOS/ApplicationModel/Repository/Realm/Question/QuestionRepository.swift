//
//  QuestionRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/16.
//

import Foundation
import RealmSwift

/// @mockable
protocol QuestionRepositoryProtocol {
    static func getQuestions(of group: String) -> [Question]
    static func add(_ question: Question) throws
    static func update(_ question: Question) throws
    static func delete(_ question: Question) throws
}

class QuestionRepositoryImpl: QuestionRepositoryProtocol {
    static func getQuestions(of group: String) -> [Question] {
        let realm = try! Realm()
        guard let group = realm.objects(QuestionGroupRealmObject.self).filter("name == %@", group).first else { return [] }
        return group.questions.map { Question(id: UUID(uuidString: $0.id) ?? UUID(), body: $0.body, group: .init(id: UUID(uuidString: group.id) ?? UUID(), name: group.name)) }
    }
    
    static func add(_ question: Question) throws {
        let realm = try! Realm()
        let questionRealmObject = QuestionRealmObject(value: ["id": question.id.uuidString, "body": question.body])
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            // TODO: 存在しないgroupの時の動作定義
            throw NSError()
        }
        try realm.write {
            questionGroupRealmObject.questions.append(questionRealmObject)
            realm.add(questionGroupRealmObject, update: .modified)
        }
    }
    
    static func update(_ question: Question) throws {
        let realm = try! Realm()
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            // TODO: 存在しないgroupの時の動作定義
            throw NSError()
        }
        guard let questionRealmObject = questionGroupRealmObject.questions.first(where: { $0.id == question.id.uuidString }) else {
            throw NSError()
        }
        
        try realm.write {
            let updateQuestionRealmObject = QuestionRealmObject(value: ["id": questionRealmObject.id, "body": question.body])
            if let index = questionGroupRealmObject.questions.firstIndex(where: { $0.id == updateQuestionRealmObject.id }) {
                questionGroupRealmObject.questions.remove(at: index)
            }
            questionGroupRealmObject.questions.append(updateQuestionRealmObject)
            realm.add(questionGroupRealmObject, update: .modified)
        }
    }
    
    static func delete(_ question: Question) throws {
        let realm = try! Realm()
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            // TODO: 存在しないgroupの時の動作定義
            throw NSError()
        }
        guard let deleteQuestionIndex = questionGroupRealmObject.questions.firstIndex(where: { $0.id == question.id.uuidString }) else {
            return
        }
        try realm.write {
            questionGroupRealmObject.questions.remove(at: deleteQuestionIndex)
            realm.add(questionGroupRealmObject, update: .modified)
        }
    }
}
