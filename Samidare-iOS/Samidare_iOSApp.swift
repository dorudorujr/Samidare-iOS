//
//  Samidare_iOSApp.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/10/23.
//

import SwiftUI
import Firebase

@main
struct Samidare_iOSApp: App {
    init() {
        FirebaseApp.configure()
        RealmConfig.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            // TODO: 正しく直す
            let interactor = try! QuestionInteractor()
            QuestionView(presenter: .init(interactor: interactor))
        }
    }
}
