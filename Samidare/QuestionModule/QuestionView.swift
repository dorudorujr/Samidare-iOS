//
//  QuestionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/08.
//

import SwiftUI
import ComposableArchitecture

struct QuestionView: View {
    let store: StoreOf<QuestionReducer>
    
    var body: some View {
        // swiftlint:disable closure_body_length
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                VStack(spacing: 20) {
                    Text(viewStore.shouldShowQuestionCount ? viewStore.questionCountText : "")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.textBlack)
                        .frame(height: 10)
                    ZStack {
                        QuestionCardView(questionBody: viewStore.shouldShowQuestionBody ? viewStore.question?.body ?? "" : "",
                                         gradationTop: viewStore.status.gradationTop,
                                         gradationBottom: viewStore.status.gradationBottom)
                        if viewStore.isReady {
                            ReadyTexts(countDownTimeText: viewStore.nowCountDownTime.description)
                        }
                    }
                    .frame(height: 220)
                    TimerProgressBar(duration: viewStore.duration, gradationTop: viewStore.status.gradationTop, gradationBottom: viewStore.status.gradationBottom)
                }
                Spacer(minLength: 0)
                HStack {
                    CircleButton(
                        action: {
                            viewStore.send(.secondaryButtonTapped)
                        },
                        title: viewStore.status.secondaryText,
                        gradationTop: Color.questionGray,
                        gradationBottom: Color.questionGray)
                    Spacer()
                    CircleButton(
                        action: {
                            viewStore.send(.primaryButtonTapped)
                        },
                        title: viewStore.status.primaryText,
                        gradationTop: Color.gradationTopBlue,
                        gradationBottom: Color.gradationBottomBlue)
                }
                AdmobBannerView().frame(width: 320, height: 50)
            }
            .padding(.horizontal, 16)
            .onAppear {
                FirebaseAnalyticsConfig.sendScreenViewLog(screenName: "\(QuestionView.self)")
            }
            .sheet(isPresented: viewStore.binding(
                get: \.shouldShowQuestionList,
                send: QuestionReducer.Action.setSheet(isPresented:)
            )) {
                QuestionListView<QuestionRepositoryImpl>(presenter: .init(interactor: .init(), group: viewStore.question?.group.name))
            }
        }
    }
}

private struct ReadyTexts: View {
    let countDownTimeText: String
    var body: some View {
        VStack(alignment: .center) {
            Text(countDownTimeText)
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
        QuestionView(
            store: Store(
                initialState: QuestionReducer.State(),
                reducer: QuestionReducer()
            )
        )
    }
}
