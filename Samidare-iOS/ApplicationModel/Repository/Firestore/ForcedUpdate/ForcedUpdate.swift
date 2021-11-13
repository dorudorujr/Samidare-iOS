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
        let data = try await document.getDocument().data(as: ForcedUpdateEntity.self)
        print("testtt:\(data?.requiredVersion)")
        //TODO: バージョンを確認する処理追加
        return false
    }
}
