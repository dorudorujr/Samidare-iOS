//
//  ContentView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/10/23.
//

import SwiftUI

struct TabTopView: View {
    @ObservedObject var presenter: TabTopPresenter
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    init(presenter: TabTopPresenter) {
        UITabBar.appearance().backgroundColor = .tabGray
        self.presenter = presenter
    }
    
    var body: some View {
        TabView {
            QuestionView(presenter: .init(interactor: .init()))
                .tabItem {
                    Image(systemName: "person.circle")
                    Text(L10n.Tab.question)
                }
            ConfigView(presenter: .init(interactor: .init()))
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
                guard let url = URL(string: presenter.getURLString()) else { return }
                openURL(url)
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
