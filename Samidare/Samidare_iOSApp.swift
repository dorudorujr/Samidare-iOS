//
//  Samidare_iOSApp.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/10/23.
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct Samidare_iOSApp: App {
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        RealmConfig.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabTopView(presenter: .init(interactor: .init()))
        }
    }
}
