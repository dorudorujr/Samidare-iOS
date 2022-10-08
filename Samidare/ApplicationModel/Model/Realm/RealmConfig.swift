//
//  RealmConfig.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/28.
//

import Foundation
import RealmSwift

struct RealmConfig {
    static func configure() {
        guard let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL else {
            return
        }
        let bundleRealmPath = Bundle.main.url(forResource: "default", withExtension: "realm")
        if !FileManager.default.fileExists(atPath: defaultRealmPath.path) {
            do {
                try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
            } catch {
                assert(true)
                print("Realm Configure Error")
            }
        }
    }
}
