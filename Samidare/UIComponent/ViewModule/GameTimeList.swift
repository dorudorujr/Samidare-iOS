//
//  GameTimeList.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/24.
//

import SwiftUI

struct GameTimeList: View {
    let appConfigGameTime: Int
    let description: String
    let tapGesture: (Int) -> Void
    var body: some View {
        List {
            Section {
                ForEach(GameTime.allCases) { gameTime in
                    ListRow(title: gameTime.rawValue.description, isSelected: appConfigGameTime == gameTime.rawValue)
                        .onTapGesture {
                            tapGesture(gameTime.rawValue)
                        }
                }
            } header: {
                Text(description)
                    .foregroundColor(.textBlack)
                    .font(.system(size: 15))
                    .padding(.bottom, 10)
            }
        }
    }
}

struct GameTimeList_Previews: PreviewProvider {
    static var previews: some View {
        GameTimeList(appConfigGameTime: 10, description: "GameTimeList", tapGesture: { _ in })
    }
}
