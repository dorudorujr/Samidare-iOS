//
//  QuestionRealmObject.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation
import RealmSwift

class QuestionRealmObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var body = ""
    
    override static func primaryKey() -> String? {
        "id"
    }
}
