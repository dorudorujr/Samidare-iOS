//
//  QuestionRealmObject.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import RealmSwift

class QuestionRealmObject: Object {
    dynamic var id = ""
    dynamic var body = ""
    dynamic var group = ""
    
    override static func primaryKey() -> String? {
        "id"
    }
}
