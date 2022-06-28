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
        guard let results = realm.objects(AppConfigRealmObject.self).first else {
            return AppConfig(questionGroup: .init(name: L10n.Common.AppConfig.questionGroup),
                             time: 10)
        }
        return AppConfig(id: UUID(uuidString: results.id) ?? UUID(),
                         questionGroup: .init(name: results.questionGroup),
                         time: results.time)
    }
    
    static func update(_ appConfig: AppConfig) throws {
        let realm = try! Realm()
        let appConfigObject = AppConfigRealmObject(value: ["id": appConfig.id.uuidString, "gameType": "", "questionGroup": appConfig.questionGroup.name, "time": appConfig.time])
        try realm.write {
            realm.add(appConfigObject, update: .modified)
        }
    }
}
