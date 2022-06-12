//
//  AppConfigSelectionType.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import Foundation

enum AppConfigSelectionType {
    case questionGroup, gameTime
    
    var description: String {
        switch self {
        case .questionGroup:
            return L10n.App.Config.Selection.Question.Group.description
        case .gameTime:
            return L10n.App.Config.Selection.Game.Time.description
        }
    }
}
