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
        GeometryReader { geometry in
            VStack(spacing: 40) {
                ZStack {
                    TimerProgressBar(duration: $presenter.duration, color: presenter.status == .ready ? .orangered : .bassBlue)
                    if presenter.status == .ready {
                        ReadyTexts(countDownTimeText: $presenter.nowCountDownTime)
                    }
                    if presenter.status == .play || presenter.status == .stop || presenter.status == .done {
                        QuestionCardView(questionBody: presenter.question?.body ?? "")
                    }
                }
                .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).width, alignment: .center)
                HStack {
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
            .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height, alignment: .center)
        }
        .padding(.horizontal, 16)
        .onAppear {
            presenter.viewWillApper()
        }
    }
}

private struct ReadyTexts: View {
    let countDownTimeText: Binding<Int>
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
