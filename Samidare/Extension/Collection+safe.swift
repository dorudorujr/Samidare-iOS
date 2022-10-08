//
//  Collection+safe.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/04/16.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
