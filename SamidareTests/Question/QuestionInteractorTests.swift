//
//  QuestionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/01/30.
//

import XCTest
@testable import Samidare

class QuestionInteractorTests: XCTestCase {
    private var interactor: QuestionInteractor<QuestionRepositoryProtocolMock, AppConfigRepositoryProtocolMock>!
    private let question = Question(body: "好きな色は", group: .init(name: "default"))
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 10)
        }
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                self.question,
                .init(body: "将来の夢は", group: .init(name: "default"))
            ]
        }
        interactor = .init()
    }
    
    func testGetQuestion() {
        // 取得成功
        XCTAssertEqual(interactor.getQuestion(from: 0)!, question)
        
        // index外
        XCTAssertNil(interactor.getQuestion(from: -1))
    }
    
    func testGetTotalQuestionCount() {
        XCTAssertEqual(interactor.getTotalQuestionCount(), 2)
    }
    
    func testGetTime() {
        XCTAssertEqual(interactor.getTime(), 10)
    }
}
