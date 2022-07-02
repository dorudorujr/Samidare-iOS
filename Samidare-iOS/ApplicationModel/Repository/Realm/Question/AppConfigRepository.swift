//
//  AppConfigRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/27.
//

import Foundation
import RealmSwift

/// @mockable
protocol AppConfigRepositoryProtocol {
    static func get() -> AppConfig
    static func update(_ appConfig: AppConfig) throws
}

class AppConfigRepositoryImpl: AppConfigRepositoryProtocol {
    static func get() -> AppConfig {
        let realm = try! Realm()
        guard let results = realm.objects(AppConfigRealmObject.self).first,
              let questionGroup = results.questionGroup else {
            return AppConfig(questionGroup: .init(name: L10n.Common.AppConfig.questionGroup),
                             time: 10)
        }
        
        let questionGroupId: UUID
        if let id = UUID(uuidString: questionGroup.id) {
            questionGroupId = id
        } else {
            questionGroupId = UUID()
        }
        
        return AppConfig(id: UUID(uuidString: results.id) ?? UUID(),
                         questionGroup: .init(id: questionGroupId,
                                              name: questionGroup.name),
                         time: results.time)
    }
    
    static func update(_ appConfig: AppConfig) throws {
        let realm = try! Realm()
        guard let questionGroup = realm.objects(QuestionGroupRealmObject.self).filter("id == %@", appConfig.questionGroup.id.uuidString).first else {
            return
        }
        let appConfigObject = AppConfigRealmObject(value: ["id": appConfig.id.uuidString, "questionGroup": questionGroup, "time": appConfig.time])
        try realm.write {
            realm.add(appConfigObject, update: .modified)
        }
    }
}
