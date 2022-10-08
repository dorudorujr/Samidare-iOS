//
//  TabTopInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/13.
//

import Foundation

class TabTopInteractor {
    private let forcedUpdate: ForcedUpdate
    
    init(forcedUpdate: ForcedUpdate = ForcedUpdate()) {
        self.forcedUpdate = forcedUpdate
    }
    
    func shouldForcedUpdate() async throws -> Bool {
        return try await forcedUpdate.shouldForcedUpdate()
    }
}
