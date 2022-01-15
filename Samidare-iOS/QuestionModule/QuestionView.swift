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
        // swiftlint:disable closure_body_length
        VStack(alignment: .center) {
            ZStack(alignment: .center) {
                TimerProgressBar(duration: $presenter.duration, color: presenter.status == .ready ? .orangered : .bassBlue)
                if presenter.status == .ready {
                    ReadyTexts(countDownTimeText: $presenter.nowCountDownTime)
                }
            }
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
        .onAppear {
            presenter.viewWillApper()
        }
    }
}

private struct ReadyTexts: View {
    var countDownTimeText: Binding<Int>
    var body: some View {
        VStack(alignment: .center) {
            Text(String(countDownTimeText.wrappedValue))
                .font(.system(size: 150))
                .fontWeight(.bold)
                .foregroundColor(Color.orangered)
                .minimumScaleFactor(0.1)
            Text(L10n.Question.Ready.text)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(Color.orangered)
                .minimumScaleFactor(0.1)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = try! QuestionInteractor()
        QuestionView(presenter: .init(interactor: interactor))
    }
}
