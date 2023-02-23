//
//  QuestionViewTests.swift
//  Samidare-iOSUITests
//
//  Created by 杉岡成哉 on 2022/02/12.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare

class QuestionViewTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryProtocolMock!
    private var questionRepositoryMock: QuestionRepositoryProtocolMock!
    private var presenter: QuestionPresenter<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>!

    override func setUp() {
        super.setUp()
        isRecording = false

        MockTimer.clearData()
        appConfigRepositoryMock = .init()
        questionRepositoryMock = .init()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroupName: "questionGroup",
                  time: 1)
        }
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
        setPresenter()
    }

    func testStandBy() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }

    func testReady() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }
    
    func testStopReadying() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        presenter.secondaryButtonAction()
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }
    
    func testPlay() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        let exp = expectation(description: "ゲーム中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }
    
    func testStopPlaying() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        let exp = expectation(description: "ゲーム中")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        presenter.secondaryButtonAction()
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }
    
    func testDone() {
        let questionView = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        let exp = expectation(description: "完了")
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
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            MockTimer.timer?.fire()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.95))
    }

    // MARK: - Set Data

    private func makeInteractory() -> QuestionInteractor<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock> {
        .init()
    }

    private func setPresenter() {
        presenter = .init(interactor: makeInteractory(), timerProvider: MockTimer.self)
    }
}
