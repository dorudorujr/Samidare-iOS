//
//  TabTopPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/13.
//

import SwiftUI

@MainActor
class TabTopPresenter: ObservableObject {
    private let interactor: TabTopInteractor
    // TODO: IDを正しいものに変える
    private let appStoreURL = "https://itunes.apple.com/jp/app/apple-store/id"
    
    @Published var shouldForcedUpdate = false
    @Environment(\.openURL) var openURL
    
    init(interactor: TabTopInteractor) {
        self.interactor = interactor
    }

    func checkForcedUpdate() async {
        do {
            shouldForcedUpdate = try await interactor.shouldForcedUpdate()
        } catch {
            Log.fault(error)
            self.shouldForcedUpdate = true
        }
    }

    func openAppStore() {
        guard let url = URL(string: appStoreURL) else { return }
        openURL(url)
    }
}
