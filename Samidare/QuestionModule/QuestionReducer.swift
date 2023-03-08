//
//  QuestionReducer.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/05.
//

import ComposableArchitecture
import SwiftUI

struct QuestionReducer: ReducerProtocol {
    struct State: Equatable {
        let readyCountDownTime = 3
        var questionCountText: String = ""
        var question: Question?
        var status: Status = .standBy
        var duration: CGFloat {
            switch self.status {
            case .standBy, .done:
                return 1.0
            case .ready, .stopReadying:
                return CGFloat(nowTime) / CGFloat(readyCountDownTime)
            case .play, .stopPlaying:
                return CGFloat(nowTime) / CGFloat(totalPlayTime)
            }
        }
        var shouldShowQuestionCount: Bool {
            status != .standBy && status != .ready && status != .stopReadying
        }
        var shouldShowQuestionBody: Bool {
            status == .play || status == .stopPlaying || status == .done
        }
        var isReady: Bool {
            status == .ready || status == .stopReadying
        }
        var shouldShowQuestionList = false
        var nowCountDownTime: String {
            Int(nowTime).description
        }
        var nowTime: Double = 0
        var totalPlayTime: Int = 1
    }
    
    enum Action: Equatable {
        case primaryButtonTapped
        case secondaryButtonTapped
        case nextQuestion
        case doneGame
        case playGame
        case timerTickedForPlaying
        case timerTickedForReadying
        case setSheet(isPresented: Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .primaryButtonTapped:
            switch state.status {
            case .standBy:
                state.status = .ready
                state.question = questionRepository.firstQuestion(of: appConfigRepository.get().questionGroupName)
                state.nowTime = Double(state.readyCountDownTime)
            case .ready:
                break
            case .play:
                guard let question = state.question else {
                    return .none
                }
                state.question = questionRepository.nextQuestion(for: question)
                state.nowTime = Double(appConfigRepository.get().time)
                FirebaseAnalyticsConfig.sendEventLog(eventType: .next)
            case .stopReadying:
                state.status = .ready
            case .stopPlaying:
                state.status = .play
            case .done:
                state.shouldShowQuestionList = true
                FirebaseAnalyticsConfig.sendEventLog(eventType: .list)
            }
            return .run { [status = state.status, question = state.question, nowTime = state.nowTime] send in
                guard status == .ready || status == .play else {
                    return
                }
                for await _ in self.clock.timer(interval: status == .play ? .milliseconds(1) : .seconds(1)) {
                    guard question != nil else {
                        await send(.doneGame)
                        return
                    }
                    
                    guard nowTime > 0 else {
                        await send(status == .ready ? .playGame : .nextQuestion)
                        return
                    }
                    
                    await send(status == .ready ? .timerTickedForReadying : .timerTickedForPlaying)
                }
            }
            .cancellable(id: TimerID.self, cancelInFlight: true)
            
        case .secondaryButtonTapped:
            guard state.status == .ready || state.status == .play else {
                state.status = .standBy
                return .cancel(id: TimerID.self)
            }
            state.status = state.status == .play ? .stopPlaying : .stopReadying
            FirebaseAnalyticsConfig.sendEventLog(eventType: .stop)
            return .none
            
        case .timerTickedForPlaying:
            state.nowTime -= 0.1
            return .none
            
        case .timerTickedForReadying:
            state.nowTime -= 1.0
            return .none
            
        case .nextQuestion:
            guard let question = state.question else {
                return .none
            }
            state.question = questionRepository.nextQuestion(for: question)
            state.nowTime = Double(appConfigRepository.get().time)
            return .none
            
        case .doneGame:
            state.status = .done
            state.nowTime = Double(state.readyCountDownTime)
            state.question = questionRepository.lastQuestion(of: appConfigRepository.get().questionGroupName)
            return .cancel(id: TimerID.self)
            
        case .playGame:
            state.status = .play
            state.nowTime = Double(appConfigRepository.get().time)
            return .none
            
        case .setSheet(isPresented: true):
            state.shouldShowQuestionList = true
            return .none
            
        case .setSheet(isPresented: false):
            state.shouldShowQuestionList = false
            return .none
        }
    }
    
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.appConfigRepository) private var appConfigRepository
    @Dependency(\.questionRepository) private var questionRepository
    
    private enum TimerID {}
}

extension QuestionReducer {
    enum Status {
        // 待機状態(初期状態)
        case standBy
        // ゲーム開始前のカウントダウン表示状態
        case ready
        // ゲーム中状態
        case play
        // ゲーム中、一時停止
        case stopPlaying
        // ゲーム開始前、一時停止
        case stopReadying
        // ゲーム終了状態、質問一覧に遷移可能
        case done
        
        var primaryText: String {
            switch self {
            case .standBy, .stopPlaying, .stopReadying:
                return L10n.Question.Start.text
            case .ready, .play:
                return L10n.Question.Next.text
            case .done:
                return L10n.Question.List.text
            }
        }
        
        var secondaryText: String {
            switch self {
            case .standBy, .stopPlaying, .stopReadying, .done:
                return L10n.Question.End.text
            case .ready, .play:
                return L10n.Question.Stop.text
            }
        }
        
        var gradationTop: Color {
            switch self {
            case .standBy, .stopPlaying, .play, .done:
                return Color.gradationTopBlue
            case .ready, .stopReadying:
                return Color.gradationTopRed
            }
        }
        
        var gradationBottom: Color {
            switch self {
            case .standBy, .stopPlaying, .play, .done:
                return Color.gradationBottomBlue
            case .ready, .stopReadying:
                return Color.gradationBottomRed
            }
        }
    }
}
