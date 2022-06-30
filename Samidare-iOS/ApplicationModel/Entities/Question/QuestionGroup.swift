//
//  QuestionGroup.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation

struct QuestionGroup: Identifiable, Equatable {
    let id: UUID
    let name: String
}

extension QuestionGroup {
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
