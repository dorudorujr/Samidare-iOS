//
//  ConfigView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import SwiftUI

struct ConfigView: View {
    @ObservedObject var presenter: ConfigPresenter
    var body: some View {
        NavigationView {
            List {
                Section {
                    ListRow(title: L10n.Config.Add.question, description: nil)
                    ListRow(title: L10n.Config.Display.group, description: $presenter.questionGroup)
                    ListRow(title: L10n.Config.Answer.seconds, description: $presenter.playTime)
                    ListRow(title: L10n.Config.mode, description: $presenter.gameType)
                }
                Section {
                    ListRow(title: L10n.Config.Use.app, description: nil)
                    ListRow(title: L10n.Config.inquiry, description: nil)
                }
                Section {
                    ListRow(title: L10n.Config.privacyPolicy, description: nil)
                    ListRow(title: L10n.Config.Terms.Of.service, description: nil)
                    ListRow(title: L10n.Config.version, description: $presenter.appVersion)
                }
            }
            .navigationTitle(L10n.Config.NavigationBar.title)
        }
        .onAppear {
            presenter.getAppConfig()
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(presenter: .init(interactor: .init()))
    }
}
