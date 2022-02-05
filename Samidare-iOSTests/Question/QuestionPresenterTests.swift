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
                  time: 2)
        }
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "将来の夢は", group: .init(name: "default"))
            ]
        }
        let interactory = try! QuestionInteractor(appConfigRepository: appConfigRepositoryMock,
                                                  questionRepository: questionRepositoryMock)
        presenter = .init(interactor: interactory)
    }
    
    func testViewWillApper() {
        XCTAssertEqual(presenter.nowCountDownTime, 0.0)
        XCTAssertEqual(presenter.totalQuestionCount, 0)
        presenter.viewWillApper()
        XCTAssertEqual(presenter.nowCountDownTime, 2.0)
        XCTAssertEqual(presenter.totalQuestionCount, 2)
    }
}
