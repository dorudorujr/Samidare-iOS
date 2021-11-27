//
//  QuestionGroupRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/23.
//

import Foundation
import RealmSwift

protocol QuestionGroupRepository {
    func get() throws -> [QuestionGroup]
    func add(_ questionGroup: QuestionGroup) throws
    func delete(_ questionGroup: QuestionGroup) throws
}

class QuestionGroupRepositoryImpl: QuestionGroupRepository {
    func get() throws -> [QuestionGroup] {
        let realm = try Realm()
        let results = realm.objects(QuestionGroupRealmObject.self)
        return results.map { QuestionGroup(name: $0.name) }
    }
    
    func add(_ questionGroup: QuestionGroup) throws {
        let realm = try Realm()
        let groupRealmObject = QuestionGroupRealmObject(value: ["id": questionGroup.id, "name": questionGroup.name])
        
        try realm.write {
            realm.add(groupRealmObject, update: .modified)
        }
    }
    
    func delete(_ questionGroup: QuestionGroup) throws {
        //TODO: 実装
        assert(true)
    }
    
    
}
