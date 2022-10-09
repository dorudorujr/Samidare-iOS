//
//  QuestionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Combine
import SwiftUI

class QuestionPresenter<QuestionRepository: QuestionRepositoryProtocol, AppConfigRepository: AppConfigRepositoryProtocol>: ObservableObject {
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
    
    private static var readyCountDownTime: Int {
        return 3
    }
    
    private let interactor: QuestionInteractor<QuestionRepository, AppConfigRepository>
    private let timerProvider: Timer.Type

    private var playTimer: Timer?
    private var countDownTimer: Timer?
    // トータルのゲーム時間
    private var totalPlayTime: Int = 0
    // 経過時間(totalPlayTimeからデクリメントで計算)
    private var nowPlayTime = 0.0
    private var selectIndex = 0 {
        didSet {
            setQuestion()
            setQuestionCountText()
        }
    }
    private var totalQuestionCount = 0 {
        didSet {
            setQuestionCountText()
        }
    }
    
    private(set) var questionGroupName: String

    var shouldShowQuestionCount: Bool {
        status != .standBy && status != .ready && status != .stopReadying
    }
    var isReady: Bool {
        status == .ready || status == .stopReadying
    }
    var shouldShowQuestionBody: Bool {
        status == .play || status == .stopPlaying || status == .done
    }

    @Published private(set) var question: Question?
    @Published private(set) var questionCountText: String = ""
    // ゲームの状態
    @Published private(set) var status: Status = .standBy
    // プログレスバーの位置
    @Published private(set) var duration: CGFloat = 1.0
    @Published var shouldShowQuestionList = false
    // 開始前のカウントダウン
    @Published var nowCountDownTime = readyCountDownTime
    
    init(interactor: QuestionInteractor<QuestionRepository, AppConfigRepository>, timerProvider: Timer.Type = Timer.self) {
        self.interactor = interactor
        self.timerProvider = timerProvider
        self.questionGroupName = interactor.questionGroup()
        setQuestion()
    }

    // MARK: - Life Cycle
    
    func viewWillApper() {
        setDefaultNowPlayTime()
        setTotalPlayTime()
        setTotalQuestionCount()
        setQuestionGroup()
    }
    
    // MARK: - Button Action
    
    func primaryButtonAction() {
        switch status {
        case .standBy:
            FirebaseAnalyticsConfig.sendEventLog(eventType: .start)
            start()
        case .stopReadying:
            start()
        case .stopPlaying:
            play()
        case .ready, .play:
            next()
        case .done:
            goToListView()
        }
    }
    
    func secondaryButtonAction() {
        switch status {
        case .standBy, .stopPlaying, .stopReadying, .done:
            end()
        case .ready, .play:
            stop()
        }
    }
    
    // MARK: - Set
    
    private func setQuestion() {
        question = interactor.getQuestion(from: selectIndex)
    }
    
    private func setDefaultNowPlayTime() {
        nowPlayTime = Double(interactor.getTime())
    }

    private func setTotalPlayTime() {
        totalPlayTime = interactor.getTime()
    }

    private func setTotalQuestionCount() {
        totalQuestionCount = interactor.getTotalQuestionCount()
    }
    
    private func setQuestionGroup() {
        questionGroupName = interactor.questionGroup()
    }
    
    private func setQuestionCountText() {
        questionCountText = "\(selectIndex + 1)/\(totalQuestionCount)"
    }

    // MARK: - Status Function
    
    private func start() {
        guard status == .standBy || status == .stopReadying else {
            assert(true)
            return
        }
        status = .ready
        countDownTimer?.invalidate()
        countDownTimer = timerProvider.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.nowCountDownTime -= 1
            self.duration = CGFloat(self.nowCountDownTime) / CGFloat(QuestionPresenter.readyCountDownTime)
            
            if self.nowCountDownTime == 0 {
                self.resetStandByConfig()
                self.play()
            }
        }
    }

    // ゲーム中
    private func play() {
        guard status == .ready || status == .stopPlaying else {
            assert(true)
            return
        }
        status = .play
        playTimer?.invalidate()
        playTimer = timerProvider.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // 最後の質問ではないかどうか
            if self.totalQuestionCount > self.selectIndex {
                self.nowPlayTime -= 0.1
                self.duration = CGFloat(self.nowPlayTime) / CGFloat(self.totalPlayTime)
                // 1つの質問を表示する時間を過ぎたかどうか
                if self.nowPlayTime < 0 {
                    self.next()
                }
            // 全ての質問を表示し終わった
            } else {
                self.duration = 1.0
                self.playTimer?.invalidate()
                self.playTimer = nil
                self.done()
            }
        }
    }
    
    // ゲーム完了
    private func done() {
        guard status == .play else {
            assert(true)
            return
        }
        // 最後に表示していた質問を表示させる
        selectIndex = totalQuestionCount - 1
        status = .done
    }
    
    // 一時停止
    private func stop() {
        guard status == .ready || status == .play else {
            assert(true)
            return
        }
        if status == .ready {
            countDownTimer?.invalidate()
        } else {
            playTimer?.invalidate()
        }
        status = status == .play ? .stopPlaying : .stopReadying
        FirebaseAnalyticsConfig.sendEventLog(eventType: .stop)
    }
    
    // MARK: - helper
    
    private func end() {
        guard status == .stopPlaying || status == .stopReadying || status == .done else {
            assert(true)
            return
        }
        status = .standBy
        resetPlayConfig()
        resetStandByConfig()
    }
    
    private func next() {
        guard status == .play else {
            assert(true)
            return
        }
        selectIndex += 1
        setDefaultNowPlayTime()
        FirebaseAnalyticsConfig.sendEventLog(eventType: .next)
    }
    
    private func goToListView() {
        shouldShowQuestionList = true
        FirebaseAnalyticsConfig.sendEventLog(eventType: .list)
    }
    
    private func resetPlayConfig() {
        selectIndex = 0
        duration = 1.0
        playTimer?.invalidate()
        playTimer = nil
        setDefaultNowPlayTime()
    }
    
    private func resetStandByConfig() {
        self.nowCountDownTime = QuestionPresenter.readyCountDownTime
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
    }
}
