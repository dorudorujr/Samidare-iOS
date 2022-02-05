//
//  QuestionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/02/04.
//

import XCTest
@testable import Samidare_iOS

class QuestionPresenterTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryMock!
    private var questionRepositoryMock: QuestionRepositoryMock!
    private var presenter: QuestionPresenter!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        questionRepositoryMock = .init()
        appConfigRepositoryMock.getHandler = {
            .init(gameType: .init(name: "gameType"),
                  questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }
        questionRepositoryMock.getQuestionsHandler = { _ in
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
        XCTAssertEqual(presenter.status, .standBy)
        XCTAssertEqual(presenter.nowCountDownTime, 3)
        presenter.primaryButtonAction()
        XCTAssertEqual(presenter.status, .ready)
        let expCountDown = expectation(description: "カウントダウン中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expCountDown.fulfill()
        }
        wait(for: [expCountDown], timeout: 0.1)
        XCTAssertEqual(presenter.nowCountDownTime, 2)
        XCTAssertEqual(presenter.duration, CGFloat(2) / CGFloat(3))
        
        // ゲーム中(ready → playへ)
        let expGoToPlay = expectation(description: "ゲーム中へ遷移")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            expGoToPlay.fulfill()
        }
        wait(for: [expGoToPlay], timeout: 0.1)
        XCTAssertEqual(presenter.nowCountDownTime, 3)
        XCTAssertEqual(presenter.status, .play)
        XCTAssertEqual(presenter.selectIndex, 0)
        
        // ゲーム中(質問表示中)
        let expPlay = expectation(description: "質問表示中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expPlay.fulfill()
        }
        wait(for: [expPlay], timeout: 0.1)
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
        XCTAssertEqual(presenter.selectIndex, 1)
        
        // ゲーム完了
        let expDone = expectation(description: "ゲーム完了")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            expDone.fulfill()
        }
        wait(for: [expDone], timeout: 0.1)
        XCTAssertEqual(presenter.duration, 1.0)
        XCTAssertEqual(presenter.status, .done)
        XCTAssertEqual(presenter.selectIndex, 0)
    }
    
    // MARK: - Set Data
    
    private func makeInteractory() -> QuestionInteractor {
        try! .init(appConfigRepository: appConfigRepositoryMock, questionRepository: questionRepositoryMock)
    }
    
    private func setPresenter() {
        presenter = .init(interactor: makeInteractory(), timerProvider: MockTimer.self)
    }
}
