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
                if presenter.shouldShowQuestionCount {
                    Text("\(presenter.selectIndex + 1)/\(presenter.totalQuestionCount)")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.textBlack)
                }
                ZStack {
                    TimerProgressBar(duration: $presenter.duration, color: presenter.isReady ? .orangered : .bassBlue)
                    if presenter.isReady {
                        ReadyTexts(countDownTimeText: $presenter.nowCountDownTime)
                    }
                    if presenter.shouldShowQuestionCardView {
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
        .sheet(isPresented: $presenter.shouldShowQuestionList) {
            QuestionListView<QuestionRepositoryImpl>(presenter: .init(interactor: .init(), group: presenter.questionGroup))
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
        QuestionView<QuestionRepositoryImpl, AppConfigRepositoryImpl>(presenter: .init(interactor: .init()))
    }
}
