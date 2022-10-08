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
        // TODO: nameで検索をかけているがidで検索をかけると狂うのでどうにかしてわかりやすく解消したい
        guard let group = realm.objects(QuestionGroupRealmObject.self).filter("name == %@", group).first else { return [] }
        return group.questions.map { Question(id: UUID(uuidString: $0.id) ?? UUID(), body: $0.body, group: .init(id: UUID(uuidString: group.id) ?? UUID(), name: group.name)) }
    }
    
    static func add(_ question: Question) throws {
        let realm = try! Realm()
        let questionRealmObject = QuestionRealmObject(value: ["id": question.id.uuidString, "body": question.body])
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            throw DataBaseGetError()
        }
        try realm.write {
            questionGroupRealmObject.questions.append(questionRealmObject)
            realm.add(questionGroupRealmObject, update: .modified)
        }
    }
    
    static func update(_ question: Question) throws {
        let realm = try! Realm()
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            throw DataBaseGetError()
        }
        guard let questionRealmObject = questionGroupRealmObject.questions.first(where: { $0.id == question.id.uuidString }) else {
            throw DataBaseGetError()
        }
        
        try realm.write {
            questionRealmObject.body = question.body
            realm.add(questionGroupRealmObject, update: .modified)
        }
    }
    
    static func delete(_ question: Question) throws {
        let realm = try! Realm()
        guard let questionGroupRealmObject = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", question.group.id.uuidString).first else {
            throw DataBaseGetError()
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
