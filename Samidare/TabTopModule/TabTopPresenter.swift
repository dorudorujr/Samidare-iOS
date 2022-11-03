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
    private let appStoreURL = "https://itunes.apple.com/jp/app/id6444154871?mt=8"
    
    @Published var shouldForcedUpdate = false
    @Environment(\.openURL) var openURL
    
    init(interactor: TabTopInteractor) {
        self.interactor = interactor
    }

    func checkForcedUpdate() async {
        do {
            shouldForcedUpdate = try await interactor.shouldForcedUpdate()
        } catch {
            Log.fault(error, className: String(describing: type(of: self)), functionName: #function)
            self.shouldForcedUpdate = true
        }
    }

    func openAppStore() {
        guard let url = URL(string: appStoreURL) else { return }
        openURL(url)
    }
}
