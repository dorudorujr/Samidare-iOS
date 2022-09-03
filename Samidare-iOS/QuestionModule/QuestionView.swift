//
//  QuestionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/08.
//

import SwiftUI

struct QuestionView<QuestionRepository: QuestionRepositoryProtocol, AppConfigRepository: AppConfigRepositoryProtocol>: View {
    @ObservedObject private var presenter: QuestionPresenter<QuestionRepository, AppConfigRepository>
    
    init(presenter: QuestionPresenter<QuestionRepository, AppConfigRepository>) {
        self.presenter = presenter
    }
    
    var body: some View {
        // swiftlint:disable closure_body_length
        GeometryReader { geometry in
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text(presenter.shouldShowQuestionCount ? presenter.questionCountText : "")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.textBlack)
                        .frame(height: 10)
                    ZStack {
                        QuestionCardView(questionBody: presenter.shouldShowQuestionBody ? presenter.question?.body ?? "" : "",
                                         gradationTop: presenter.status.gradationTop,
                                         gradationBottom: presenter.status.gradationBottom)
                        if presenter.isReady {
                            ReadyTexts(countDownTimeText: $presenter.nowCountDownTime)
                        }
                    }
                    TimerProgressBar(duration: presenter.duration, gradationTop: presenter.status.gradationTop, gradationBottom: presenter.status.gradationBottom)
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
        .sheet(isPresented: $presenter.shouldShowQuestionList) {
            QuestionListView<QuestionRepositoryImpl>(presenter: .init(interactor: .init(), group: presenter.questionGroupName))
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
                .foregroundColor(.white)
                .minimumScaleFactor(0.1)
            Text(L10n.Question.Ready.text)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .minimumScaleFactor(0.1)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView<QuestionRepositoryImpl, AppConfigRepositoryImpl>(presenter: .init(interactor: .init()))
    }
}
