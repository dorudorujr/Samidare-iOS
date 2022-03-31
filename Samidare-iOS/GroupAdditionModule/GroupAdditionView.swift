//
//  GroupAdditionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import SwiftUI

struct GroupAdditionView: View {
    @ObservedObject private var presenter: GroupAdditionPresenter
    
    init(presenter: GroupAdditionPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    if let groups = self.presenter.groups {
                        ForEach(groups) { group in
                            Text(group.name)
                                .font(.system(size: 17))
                                .foregroundColor(Color.textBlack)
                        }
                    }
                }
            }
            .navigationTitle(L10n.Group.Addition.title)
            .navigationBarTitleDisplayMode(.inline)
            //TODO: グループ追加ボタンの動作&UI実装
        }
    }
}

struct GroupAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        GroupAdditionView(presenter: .init(interactor: .init()))
    }
}
