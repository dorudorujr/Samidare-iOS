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
        let result = realm.objects(AppConfigRealmObject.self).first!
        let jsonData = result.json.data(using: .utf8)!
        return try! JSONDecoder().decode(AppConfig.self, from: jsonData)
    }
    
    static func update(_ appConfig: AppConfig) throws {
        let realm = try! Realm()
        let data = try JSONEncoder().encode(appConfig)
        let jsonString = String(data: data, encoding: .utf8)
        let appConfigObject = AppConfigRealmObject(value: ["json": jsonString])
        try realm.write {
            let cashAppConfigObjects = realm.objects(AppConfigRealmObject.self)
            cashAppConfigObjects.forEach { appConfigObject in
                realm.delete(appConfigObject)
            }
            realm.add(appConfigObject)
        }
    }
}
