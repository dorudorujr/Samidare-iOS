//
//  QuestionGroupRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/23.
//

import Foundation
import RealmSwift

/// @mockable
protocol QuestionGroupRepositoryProtocol {
    static func get() -> [QuestionGroup]
    static func add(_ questionGroup: QuestionGroup) throws
    static func delete(_ questionGroup: QuestionGroup) throws
}

class QuestionGroupRepositoryImpl: QuestionGroupRepositoryProtocol {
    static func get() -> [QuestionGroup] {
        let realm = try! Realm()
        let results = realm.objects(QuestionGroupRealmObject.self)
        return results.map { QuestionGroup(id: UUID(uuidString: $0.id) ?? UUID(),
                                           name: $0.name)}
    }
    
    static func add(_ questionGroup: QuestionGroup) throws {
        let realm = try! Realm()
        guard realm.objects(QuestionGroupRealmObject.self).filter("name == %@", questionGroup.name).isEmpty else { return }
        let groupRealmObject = QuestionGroupRealmObject(value: ["id": questionGroup.id.uuidString, "name": questionGroup.name])
        
        try realm.write {
            realm.add(groupRealmObject, update: .modified)
        }
    }
    
    static func delete(_ questionGroup: QuestionGroup) throws {
        let realm = try! Realm()
        guard let groupResult = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", questionGroup.id.uuidString).first else {
            return
        }
        try realm.write {
            realm.delete(groupResult)
        }
    }
}
