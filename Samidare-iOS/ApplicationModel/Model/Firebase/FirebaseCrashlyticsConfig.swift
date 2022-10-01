//
//  FirebaseCrashlyticsConfig.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/10/01.
//

import Firebase

struct FirebaseCrashlyticsConfig {
    static func record(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
