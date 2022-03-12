//
//  ContentView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/10/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .tabGray
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
