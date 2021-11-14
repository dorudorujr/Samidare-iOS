//
//  QuestionDictionaryRealmObject.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import RealmSwift

class QuestionDictionaryRealmObject: Object {
    dynamic var groupName = ""
    let list = List<QuestionListRealmObject>()
}
