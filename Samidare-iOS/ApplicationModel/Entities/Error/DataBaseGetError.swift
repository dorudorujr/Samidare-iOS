//
//  DataBaseGetError.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/09/30.
//

import Foundation

struct DataBaseGetError: Error {
    let code: Int = -4000
    var localizedDescription: String = "Database get error"
}
