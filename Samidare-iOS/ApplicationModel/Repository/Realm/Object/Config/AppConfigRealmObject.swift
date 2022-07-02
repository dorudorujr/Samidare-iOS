//
//  AppConfigRealmObject.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import RealmSwift
import Foundation

class AppConfigRealmObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var questionGroup: QuestionGroupRealmObject?
    @objc dynamic var time = 0
    
    override static func primaryKey() -> String? {
        "id"
    }
}
