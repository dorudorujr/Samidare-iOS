//
//  QuestionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/01/30.
//

import XCTest
@testable import Samidare_iOS

class QuestionInteractorTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryMock!
    private var questionRepositoryMock: QuestionRepositoryMock!
    private var interactor: QuestionInteractor!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        questionRepositoryMock = .init()
        appConfigRepositoryMock.getHandler = {
            .init(gameType: .init(name: "gameType"),
                  questionGroup: .init(name: "questionGroup"),
                  time: 10)
        }
        interactor = try! .init(appConfigRepository: appConfigRepositoryMock,
                                questionRepository: questionRepositoryMock)
    }
    
    func testGetQuestion() {
        // 取得成功
        setGetQuestionsHandler()
        XCTAssertEqual(try! interactor.getQuestion(from: 0)!.body, "好きな色は")
        XCTAssertEqual(try! interactor.getQuestion(from: 0)!.group.name, "default")
    }
    
    func testGetTotalQuestionCount() {
        setGetQuestionsHandler()
        XCTAssertEqual(try! interactor.getTotalQuestionCount(), 2)
    }
    
    func testGetTime() {
        XCTAssertEqual(try! interactor.getTime(), 10)
    }
    
    private func setGetQuestionsHandler() {
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "将来の夢は", group: .init(name: "default"))
            ]
        }
    }
}
