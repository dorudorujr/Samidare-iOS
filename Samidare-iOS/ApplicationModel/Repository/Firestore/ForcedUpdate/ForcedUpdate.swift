//
//  ForcedUpdate.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ForcedUpdate {
    let document = Firestore.firestore().collection("version").document("forced_update")
    
    func shouldForcedUpdate() async throws -> Bool {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let data = try await document.getDocument().data(as: ForcedUpdateEntity.self)
        guard let data = data, let appVersion = appVersion else { return true }
        return appVersion < data.requiredVersion
    }
}
