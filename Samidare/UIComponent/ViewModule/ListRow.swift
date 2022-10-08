//
//  ListRow.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import SwiftUI

struct ListRow: View {
    let title: String
    let description: String?
    let isSelected: Bool?
    let shouldShowArrow: Bool
    
    init(title: String,
         description: String? = nil,
         isSelected: Bool? = nil,
         shouldShowArrow: Bool = false) {
        self.title = title
        self.description = description
        self.isSelected = isSelected
        self.shouldShowArrow = shouldShowArrow
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(Color.textBlack)
            Spacer()
            if let description = description {
                Text(description)
                    .font(.system(size: 17))
                    .foregroundColor(Color.textGray)
            }
            if let isSelected = isSelected, isSelected {
                Image(systemName: "checkmark")
                    .renderingMode(.template)
                    .foregroundColor(.blue)
            }
            if shouldShowArrow {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 7)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())  // 文字列以外もTapできるようにする
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(title: "title", description: "description")
    }
}
