//
//  QuestionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/01/30.
//

import XCTest
@testable import Samidare_iOS

class QuestionInteractorTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryProtocolMock!
    private var questionRepositoryMock: QuestionRepositoryProtocolMock!
    private var interactor: QuestionInteractor<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        questionRepositoryMock = .init()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 10)
        }
        interactor = .init()
    }
    
    func testGetQuestion() {
        // 取得成功
        setGetQuestionsHandler()
        XCTAssertEqual(interactor.getQuestion(from: 0)!.body, "好きな色は")
        XCTAssertEqual(interactor.getQuestion(from: 0)!.group.name, "default")
    }
    
    func testGetTotalQuestionCount() {
        setGetQuestionsHandler()
        XCTAssertEqual(interactor.getTotalQuestionCount(), 2)
    }
    
    func testGetTime() {
        XCTAssertEqual(interactor.getTime(), 10)
    }
    
    private func setGetQuestionsHandler() {
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "将来の夢は", group: .init(name: "default"))
            ]
        }
    }
}
