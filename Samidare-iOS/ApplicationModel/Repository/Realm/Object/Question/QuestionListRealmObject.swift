//
//  QuestionList.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import RealmSwift
import Foundation

class QuestionListRealmObject: Object {
    @objc dynamic var groupName = ""
    let list = List<QuestionRealmObject>()
    
    override static func primaryKey() -> String? {
        "groupName"
    }
}
