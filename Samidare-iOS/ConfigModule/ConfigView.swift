//
//  ConfigView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import SwiftUI

struct ConfigView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    ListRow(title: L10n.Config.Add.question, description: nil)
                    ListRow(title: L10n.Config.Display.group, description: "デフォルト")
                    ListRow(title: L10n.Config.Answer.seconds, description: "20秒")
                    ListRow(title: L10n.Config.mode, description: "シングル")
                }
                Section {
                    ListRow(title: L10n.Config.Use.app, description: nil)
                    ListRow(title: L10n.Config.inquiry, description: nil)
                }
                Section {
                    ListRow(title: L10n.Config.privacyPolicy, description: nil)
                    ListRow(title: L10n.Config.Terms.Of.service, description: nil)
                    ListRow(title: L10n.Config.version, description: "1.0.0")
                }
            }
            .navigationTitle(L10n.Config.NavigationBar.title)
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
