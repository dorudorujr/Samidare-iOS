//
//  QuestionRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/16.
//

import Foundation
import RealmSwift

/// @mockable
protocol QuestionRepository {
    func getQuestions(of group: String) -> [Question]
    func add(_ question: Question) throws
    func update(_ question: Question) throws
    func delete(_ question: Question) throws
}

class QuestionRepositoryImpl: QuestionRepository {
    func getQuestions(of group: String) -> [Question] {
        let realm = try! Realm()
        guard let results = realm.objects(QuestionListRealmObject.self).filter("groupName == %@", group).first else { return [] }
        return results.list.map { Question(id: UUID(uuidString: $0.id) ?? UUID(), body: $0.body, group: QuestionGroup(name: $0.group)) }
    }
    
    func add(_ question: Question) throws {
        let realm = try! Realm()
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
        let realm = try! Realm()
        let updateQuestionRealmObject = QuestionRealmObject(value: ["id": question.id.uuidString, "body": question.body, "group": question.group.name])
        
        try realm.write {
            guard let storeQuestionListRealmObject = realm.objects(QuestionListRealmObject.self).filter("groupName == %@", question.group.name).first else {
                return
            }
            if let storeQuestion = storeQuestionListRealmObject.list.first(where: { $0.id == updateQuestionRealmObject.id }) {
                storeQuestion.body = updateQuestionRealmObject.body
            } else {
                storeQuestionListRealmObject.list.append(updateQuestionRealmObject)
            }
            realm.add(storeQuestionListRealmObject, update: .modified)
        }
    }
    
    func delete(_ question: Question) throws {
        let realm = try! Realm()
        guard let storeQuestionListRealmObject = realm.objects(QuestionListRealmObject.self).filter("groupName == %@", question.group.name).first else {
            return
        }
        guard let index = storeQuestionListRealmObject.list.firstIndex(where: { $0.id == question.id.uuidString }) else { return }
        try realm.write {
            storeQuestionListRealmObject.list.remove(at: index)
            realm.add(storeQuestionListRealmObject, update: .modified)
        }
    }
}
