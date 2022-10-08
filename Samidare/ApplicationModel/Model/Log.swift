//
//  Log.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/10/01.
//

import Firebase
import os

struct Log {
    static func fault(_ error: Error, className: String, functionName: String) {
        let logger = Logger(subsystem: "com.sugiokaseiya", category: "fault")
        logger.fault("⚠️⚠️Error⚠️⚠️:\(error.localizedDescription),class: \(className), function: \(functionName)")
        Crashlytics.crashlytics().log("class: \(className), function: \(functionName)")
        Crashlytics.crashlytics().record(error: error)
    }
}
