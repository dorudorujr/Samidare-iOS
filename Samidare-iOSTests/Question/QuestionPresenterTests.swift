//
//  QuestionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/02/04.
//

import XCTest
@testable import Samidare_iOS

class QuestionPresenterTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryProtocolMock!
    private var questionRepositoryMock: QuestionRepositoryProtocolMock!
    private var presenter: QuestionPresenter<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        MockTimer.clearData()
        appConfigRepositoryMock = .init()
        questionRepositoryMock = .init()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
        setPresenter()
    }
    
    func testViewWillApper() {
        XCTAssertEqual(presenter.totalQuestionCount, 0)
        presenter.viewWillApper()
        XCTAssertEqual(presenter.totalQuestionCount, 1)
    }
    
    // PrimaryButtonActionの一連の流れをテスト
    func testPrimaryButtonAction() {
        // 初期化
        presenter.viewWillApper()
        
        // カウントダウン中
        /// ステータス確認
        XCTAssertEqual(presenter.status, .standBy)
        /// 現在のカウントダウンタイムが初期表示であるか確認
        XCTAssertEqual(presenter.nowCountDownTime, 3)
        
        presenter.primaryButtonAction()
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .ready)
        let expCountDown = expectation(description: "カウントダウン中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expCountDown.fulfill()
        }
        wait(for: [expCountDown], timeout: 0.1)
        /// 現在のカウントダウンタイムが1秒進んでいることの確認
        XCTAssertEqual(presenter.nowCountDownTime, 2)
        /// プログレスバーの範囲計算が正常に行われているか確認
        XCTAssertEqual(presenter.duration, CGFloat(2) / CGFloat(3))
        
        // ゲーム中(ready → playへ)
        let expGoToPlay = expectation(description: "ゲーム中へ遷移")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expGoToPlay.fulfill()
        }
        wait(for: [expGoToPlay], timeout: 0.1)
        /// 準備期間が終了したらカウントダウンタイムが初期化されているか確認
        XCTAssertEqual(presenter.nowCountDownTime, 3)
        /// ステータス確認
        XCTAssertEqual(presenter.status, .play)
        /// 質問のインデックスが初期表示か確認
        XCTAssertEqual(presenter.selectIndex, 0)
        
        // ゲーム中(質問表示中)
        let expPlay = expectation(description: "質問表示中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expPlay.fulfill()
        }
        wait(for: [expPlay], timeout: 0.1)
        /// プログレスバーの範囲計算が正常に行われているか確認
        /// 0.1秒進んでいるか確認
        XCTAssertEqual(presenter.duration, CGFloat(1.0 - 0.1) / CGFloat(1.0))
        
        // ゲーム中(１つの質問を表示する時間を経過)
        let expOverTime = expectation(description: "質問表示時間経過")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            // 残り0.9秒を経過させたい
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expOverTime.fulfill()
        }
        wait(for: [expOverTime], timeout: 0.1)
        /// 質問時間経過で次の質問に行っているか確認
        XCTAssertEqual(presenter.selectIndex, 1)
        
        // ゲーム完了
        let expDone = expectation(description: "ゲーム完了")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expDone.fulfill()
        }
        wait(for: [expDone], timeout: 0.1)
        /// ゲーム完了後はプログレスバーを全表示に
        XCTAssertEqual(presenter.duration, 1.0)
        /// ステータス確認
        XCTAssertEqual(presenter.status, .done)
        /// ゲーム完了後は一番最後に表示した質問を表示
        XCTAssertEqual(presenter.selectIndex, 0)
    }
    
    func testNext() {
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "将来の夢は", group: .init(name: "default"))
            ]
        }
        setPresenter()
        
        // 初期化
        presenter.viewWillApper()
        
        presenter.primaryButtonAction()
        let expNextBefore = expectation(description: "ゲーム中まで進める")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expNextBefore.fulfill()
        }
        wait(for: [expNextBefore], timeout: 0.1)
        
        /// 質問の総数確認
        XCTAssertEqual(presenter.totalQuestionCount, 2)
        /// indexが初期値かどうか確認
        XCTAssertEqual(presenter.selectIndex, 0)
        /// プログレスバーの範囲が進んでいるかどうか
        XCTAssertEqual(presenter.duration, CGFloat(1.0 - 0.2) / CGFloat(1.0))
        
        presenter.primaryButtonAction()
        
        let expNextAfter = expectation(description: "Next後のTimer")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expNextAfter.fulfill()
        }
        wait(for: [expNextAfter], timeout: 0.1)
        
        /// indexが次に進んでいるか確認
        XCTAssertEqual(presenter.selectIndex, 1)
        /// プログレスバーの範囲が初回表示時の範囲かどうか
        XCTAssertEqual(presenter.duration, CGFloat(1.0 - 0.1) / CGFloat(1.0))
    }
    
    func testSecondaryButtonAction() {
        // 初期化
        presenter.viewWillApper()
        
        presenter.primaryButtonAction()
        let expCountDown = expectation(description: "カウントダウン中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expCountDown.fulfill()
        }
        wait(for: [expCountDown], timeout: 0.1)
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .ready)
        /// invalidate実行確認
        XCTAssertEqual(MockTimer.callCountInvalidate, 0)
        
        XCTAssertFalse(presenter.shouldShowQuestionCount)
        XCTAssertTrue(presenter.isReady)
        XCTAssertFalse(presenter.shouldShowQuestionCardView)
        
        presenter.secondaryButtonAction()
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .stopReadying)
        /// invalidate実行確認
        XCTAssertEqual(MockTimer.callCountInvalidate, 1)
        
        XCTAssertFalse(presenter.shouldShowQuestionCount)
        XCTAssertTrue(presenter.isReady)
        XCTAssertFalse(presenter.shouldShowQuestionCardView)
        
        presenter.primaryButtonAction()
        
        let expGoToPlay = expectation(description: "ゲーム中へ遷移")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expGoToPlay.fulfill()
        }
        wait(for: [expGoToPlay], timeout: 0.1)
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .play)
        /// invalidate実行確認
        XCTAssertEqual(MockTimer.callCountInvalidate, 3)
        
        XCTAssertTrue(presenter.shouldShowQuestionCount)
        XCTAssertFalse(presenter.isReady)
        XCTAssertTrue(presenter.shouldShowQuestionCardView)
        
        presenter.secondaryButtonAction()
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .stopPlaying)
        /// invalidate実行確認
        XCTAssertEqual(MockTimer.callCountInvalidate, 4)
        
        XCTAssertTrue(presenter.shouldShowQuestionCount)
        XCTAssertFalse(presenter.isReady)
        XCTAssertTrue(presenter.shouldShowQuestionCardView)
        
        presenter.primaryButtonAction()
        
        // ゲーム完了
        let expDone = expectation(description: "ゲーム完了")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expDone.fulfill()
        }
        wait(for: [expDone], timeout: 0.1)
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .done)
        
        XCTAssertTrue(presenter.shouldShowQuestionCount)
        XCTAssertFalse(presenter.isReady)
        XCTAssertTrue(presenter.shouldShowQuestionCardView)
        
        presenter.secondaryButtonAction()
        
        /// ステータス確認
        XCTAssertEqual(presenter.status, .standBy)
        
        XCTAssertFalse(presenter.shouldShowQuestionCount)
        XCTAssertFalse(presenter.isReady)
        XCTAssertFalse(presenter.shouldShowQuestionCardView)
        
        // TODO: 初期化確認
        /// 初期化確認
        XCTAssertEqual(presenter.selectIndex, 0)
        XCTAssertEqual(presenter.duration, 1.0)
        XCTAssertEqual(presenter.nowCountDownTime, 3)
        XCTAssertEqual(MockTimer.callCountInvalidate, 6)
    }
    
    // MARK: - Set Data
    
    private func makeInteractory() -> QuestionInteractor<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock> {
        .init()
    }
    
    private func setPresenter() {
        presenter = .init(interactor: makeInteractory(), timerProvider: MockTimer.self)
    }
}
