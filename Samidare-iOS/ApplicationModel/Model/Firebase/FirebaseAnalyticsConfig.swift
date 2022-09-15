//
//  FirebaseAnalyticsConfig.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/09/14.
//

import Firebase

struct FirebaseAnalyticsConfig {
    enum EventType: String {
        case start = "game_start"
        case next = "question_next"
        case stop = "game_stop"
        case list = "question_list"
        case addQuestionGroup = "add_question_group"
        case addQuestion = "add_question"
        case deleteQuestionGroup = "delete_question_group"
    }
    
    static func sendEventLog(eventType: EventType) {
        Analytics.logEvent(eventType.rawValue, parameters: nil)
    }
    
    static func sendScreenViewLog(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenName])
    }
}
