//
//  TabTopPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/13.
//

import Foundation

@MainActor
class TabTopPresenter: ObservableObject {
    private let interactor: TabTopInteractor
    // TODO: IDを正しいものに変える
    private let appId = "id"
    
    @Published var shouldForcedUpdate = false
    
    init(interactor: TabTopInteractor) {
        self.interactor = interactor
    }

    func viewDidAppear() async {
        do {
            shouldForcedUpdate = try await interactor.shouldForcedUpdate()
        } catch {
            self.shouldForcedUpdate = true
        }
    }
    
    func getURLString() -> String {
        "https://itunes.apple.com/jp/app/apple-store/id" + appId
    }
}
