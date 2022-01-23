//
//  QuestionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Combine
import SwiftUI

class QuestionPresenter: ObservableObject {
    enum Status {
        case standBy, ready, play, stop, done
        
        var primaryText: String {
            switch self {
            case .standBy, .stop:
                return L10n.Question.Start.text
            case .ready, .play:
                return L10n.Question.Next.text
            case .done:
                return L10n.Question.List.text
            }
        }
        
        var secondaryText: String {
            switch self {
            case .standBy, .stop, .done:
                return L10n.Question.End.text
            case .ready, .play:
                return L10n.Question.Stop.text
            }
        }
    }
    
    private static let countDownTime = 3
    
    private let interactor: QuestionInteractor

    private var playTimer: Timer?
    private var countDownTimer: Timer?
    // ゲーム時間
    private var playTime: Int = 0
    // ゲーム中のカウントダウン
    private var nowPlayTime = 0.0

    @Published var question: Question?
    @Published var error: Error?
    @Published var selectIndex = 0 {
        didSet {
            setQuestion()
        }
    }
    // ゲームの状態
    @Published var status: Status = .standBy
    // プログレスバーの位置
    @Published var duration: CGFloat = 1.0
    // 開始前のカウントダウン
    @Published var nowCountDownTime = countDownTime
    // 質問の総数
    @Published var totalQuestionCount = 0
    
    init(interactor: QuestionInteractor) {
        self.interactor = interactor
        setQuestion()
    }

    // MARK: - Life Cycle
    
    func viewWillApper() {
        setNowPlayTime()
        setPlayTime()
        setTotalQuestionCount()
    }
    
    // MARK: - Button Action
    
    func primaryButtonAction() {
        switch status {
        case .standBy, .stop:
            start()
        case .ready, .play:
            next()
        case .done:
            goToListView()
        }
    }
    
    func secondaryButtonAction() {
        switch status {
        case .standBy, .stop, .done:
            end()
        case .ready, .play:
            stop()
        }
    }
    
    // MARK: - Set
    
    private func setQuestion() {
        do {
            question = try interactor.getQuestion(from: selectIndex)
        } catch {
            self.error = error
        }
    }
    
    private func setNowPlayTime() {
        do {
            nowPlayTime = Double(try interactor.getTime())
        } catch {
            self.error = error
        }
    }

    private func setPlayTime() {
        do {
            playTime = try interactor.getTime()
        } catch {
            self.error = error
        }
    }

    private func setTotalQuestionCount() {
        do {
            totalQuestionCount = try interactor.getTotalQuestionCount()
        } catch {
            self.error = error
        }
    }

    // MARK: - Status Function
    
    private func start() {
        guard status == .standBy || status == .stop else {
            assert(true)
            return
        }
        status = .ready
        countDownTimer?.invalidate()
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.nowCountDownTime -= 1
            self.duration = CGFloat(self.nowCountDownTime) / CGFloat(QuestionPresenter.countDownTime)
            
            if self.nowCountDownTime == 0 {
                self.resetStandByConfig()
                self.play()
            }
        }
    }

    private func play() {
        guard status == .ready || status == .stop else {
            assert(true)
            return
        }
        status = .play
        playTimer?.invalidate()
        playTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // 最後の質問かどうか
            if self.totalQuestionCount > self.selectIndex {
                self.nowPlayTime -= 0.1
                self.duration = CGFloat(self.nowPlayTime) / CGFloat(self.playTime)
                // 1つの質問を表示する時間を過ぎたかどうか
                if self.nowPlayTime == 0 {
                    self.selectIndex += 1
                    self.setNowPlayTime()
                }
            // 全ての質問を表示し終わった
            } else {
                self.resetPlayConfig()
                self.done()
            }
        }
    }
    
    private func done() {
        guard status == .play else {
            assert(true)
            return
        }
        status = .done
    }
    
    private func stop() {
        guard status == .ready || status == .play else {
            assert(true)
            return
        }
        status = .stop
        if status == .ready {
            countDownTimer?.invalidate()
        } else {
            playTimer?.invalidate()
        }
    }
    
    // MARK: - helper
    
    private func end() {
        guard status == .stop || status == .done else {
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
        setNowPlayTime()
    }
    
    private func goToListView() {
        //TODO: 一覧画面への遷移実装
    }
    
    private func resetPlayConfig() {
        selectIndex = 0
        duration = 1.0
        playTimer?.invalidate()
        playTimer = nil
        setNowPlayTime()
    }
    
    private func resetStandByConfig() {
        self.nowCountDownTime = QuestionPresenter.countDownTime
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
    }
}
