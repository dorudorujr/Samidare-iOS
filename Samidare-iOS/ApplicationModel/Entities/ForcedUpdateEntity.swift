//
//  ForcedUpdate.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/13.
//

import Foundation

public struct ForcedUpdateEntity: Codable {
    public let canCancel: Bool
    public let enabledAt: String
    public let requiredVersion: String

    private enum CodingKeys: String, CodingKey {
        case canCancel = "can_cancel"
        case enabledAt = "enabled_at"
        case requiredVersion = "required_version"
    }
}

extension ForcedUpdateEntity: Equatable {}
