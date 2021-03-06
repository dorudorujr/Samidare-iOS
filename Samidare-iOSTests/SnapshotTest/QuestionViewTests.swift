//
//  QuestionViewTests.swift
//  Samidare-iOSUITests
//
//  Created by 杉岡成哉 on 2022/02/12.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare_iOS

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

    func testStandBy() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }

    func testReady() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }
    
    func testStopReadying() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
        presenter.viewWillApper()
        presenter.primaryButtonAction()
        presenter.secondaryButtonAction()
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }
    
    func testPlay() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
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
        wait(for: [exp], timeout: 0.1)
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }
    
    func testStopPlaying() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
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
        wait(for: [exp], timeout: 0.1)
        presenter.secondaryButtonAction()
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }
    
    func testDone() {
        let view = QuestionView<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>(presenter: presenter)
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
        wait(for: [exp], timeout: 0.1)
        assertSnapshot(matching: view.referenceFrame(),
                       as: .image)
    }

    // MARK: - Set Data

    private func makeInteractory() -> QuestionInteractor<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock> {
        .init()
    }

    private func setPresenter() {
        presenter = .init(interactor: makeInteractory(), timerProvider: MockTimer.self)
    }
}
