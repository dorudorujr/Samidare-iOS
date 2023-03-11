//
//  ContentView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/10/23.
//

import SwiftUI
import ComposableArchitecture

struct TabTopView: View {
    @ObservedObject private var presenter: TabTopPresenter
    @Environment(\.scenePhase) private var scenePhase

    private let questionView = QuestionView(
        store: Store(
            initialState: QuestionReducer.State(),
            reducer: QuestionReducer()
        )
    )
    private let configView = ConfigView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    
    init(presenter: TabTopPresenter) {
        UITabBar.appearance().backgroundColor = .tabGray
        self.presenter = presenter
        AdMobConfig.checkTrackingAuthorizationStatus()
    }
    
    var body: some View {
        TabView {
            questionView
                .tabItem {
                    Image(systemName: "person.circle")
                    Text(L10n.Tab.question)
                }
            configView
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(L10n.Tab.config)
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                Task {
                    await presenter.checkForcedUpdate()
                }
            }
        }
        .alert(L10n.ForcedUpdate.title, isPresented: $presenter.shouldForcedUpdate) {
            Button(L10n.Common.ok) {
                presenter.openAppStore()
            }
        } message: {
            Text(L10n.ForcedUpdate.description)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabTopView(presenter: .init(interactor: .init()))
    }
}
