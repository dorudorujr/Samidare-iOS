//
//  QuestionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/08.
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var presenter: QuestionPresenter
    var body: some View {
        VStack(alignment: .center) {
            TimerProgressBar(duration: $presenter.duration)
            HStack(alignment: .center) {
                CircleButton(
                    action: {
                        presenter.secondaryButtonAction()
                    },
                    title: presenter.status.secondaryText,
                    color: Color.questionGray)
                Spacer()
                CircleButton(
                    action: {
                        presenter.primaryButtonAction()
                    },
                    title: presenter.status.primaryText,
                    color: Color.bassBlue)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = try! QuestionInteractor()
        QuestionView(presenter: .init(interactor: interactor))
    }
}
