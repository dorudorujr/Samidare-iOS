//
//  ListRow.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import SwiftUI

struct ListRow: View {
    let title: String
    let description: Binding<String?>?
    
    init(title: String, description: Binding<String?>? = nil) {
        self.title = title
        self.description = description
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(Color.textBlack)
            Spacer()
            if let description = description, let text = description.wrappedValue {
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.textGray)
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(title: "title", description: .constant("description"))
    }
}
