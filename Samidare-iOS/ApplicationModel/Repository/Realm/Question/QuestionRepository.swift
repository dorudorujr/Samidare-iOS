//
//  QuestionRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/16.
//

import Foundation
import RealmSwift

protocol QuestionRepository {
    func getQuestions(of group: String) throws -> [Question]
    func add(_ question: Question) throws
    func update(_ question: Question) throws
    func delete(_ question: Question, of group: String) throws
}

class QuestionRepositoryImpl: QuestionRepository {
    func getQuestions(of group: String) throws -> [Question] {
        let realm = try Realm()
        guard let results = realm.objects(QuestionListRealmObject.self).filter("groupName == %@", group).first else { return [] }
        return results.list.map { Question(body: $0.body, group: QuestionGroup(name: $0.group)) }
    }
    
    func add(_ question: Question) throws {
        let realm = try Realm()
        let questionRealmObject = QuestionRealmObject(value: ["id": question.id.uuidString, "body": question.body, "group": question.group.name])
        var addQuestionListRealmObject = QuestionListRealmObject()
        try realm.write {
            if let storeQuestionListRealmObject = realm.objects(QuestionListRealmObject.self).filter("groupName == %@", question.group.name).first {
                storeQuestionListRealmObject.list.append(questionRealmObject)
                addQuestionListRealmObject = storeQuestionListRealmObject
            } else {
                addQuestionListRealmObject.list.append(questionRealmObject)
                addQuestionListRealmObject.groupName = question.group.name
            }
            realm.add(addQuestionListRealmObject, update: .modified)
        }
    }
    
    func update(_ question: Question) throws {
        let realm = try Realm()
        let questionRealmObject = QuestionRealmObject(value: ["id": question.id, "body": question.body, "group": question.group.name])
        
        try realm.write {
            realm.add(questionRealmObject, update: .modified)
        }
    }
    
    func delete(_ question: Question, of group: String) throws {
        // TODO: 実装
        assert(true)
    }
}
