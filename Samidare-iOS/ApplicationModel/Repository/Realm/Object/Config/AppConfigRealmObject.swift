//
//  AppConfigRealmObject.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import RealmSwift

class AppConfigRealmObject: Object {
    dynamic var gameType = ""
    dynamic var questionGroup = ""
    dynamic var time = 0
}
