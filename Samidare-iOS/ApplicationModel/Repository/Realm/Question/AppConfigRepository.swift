//
//  AppConfigRepository.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/27.
//

import Foundation
import RealmSwift

protocol AppConfigRepository {
    func get() throws -> AppConfig
    func update(_ appConfig: AppConfig) throws
}

class AppConfigRepositoryImpl: AppConfigRepository {
    func get() throws -> AppConfig {
        let realm = try Realm()
        guard let results = realm.objects(AppConfigRealmObject.self).first else {
            return AppConfig(gameType: .init(name: L10n.Common.AppConfig.gameType),
                             questionGroup: .init(name: L10n.Common.AppConfig.questionGroup),
                             time: 10)
        }
        return AppConfig(gameType: .init(name: results.gameType),
                         questionGroup: .init(name: results.questionGroup),
                         time: results.time)
    }
    
    func update(_ appConfig: AppConfig) throws {
        let realm = try Realm()
        let appConfigObject = AppConfigRealmObject(value: ["id": appConfig.id.uuidString, "gameType": appConfig.gameType.name, "questionGroup": appConfig.questionGroup.name, "time": appConfig.time])
        try realm.write {
            realm.add(appConfigObject, update: .modified)
        }
    }
}