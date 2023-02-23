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
    private let firstQuestion = Question(body: "好きな色は", group: .init(name: "default"))
    private let secondQuestion = Question(body: "将来の夢は", group: .init(name: "default"))
    private let lastQuestion = Question(body: "好きな食べ物は", group: .init(name: "default"))
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroupName: "questionGroup",
                  time: 10)
        }
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                self.firstQuestion,
                self.secondQuestion,
                self.lastQuestion
            ]
        }
        interactor = .init()
    }
    
    func testNextQuestion() {
        // 存在しない質問
        // 存在しない質問の場合は最初の質問を返す
        XCTAssertEqual(interactor.nextQuestion(for: .init(body: "存在しない質問", group: .init(name: "default"))), firstQuestion)
        
        // 次の質問を取得
        XCTAssertEqual(interactor.nextQuestion(for: firstQuestion), secondQuestion)
        
        // 最後の質問
        XCTAssertNil(interactor.nextQuestion(for: lastQuestion))
    }
    
    func testFirstQuestion() {
        XCTAssertEqual(interactor.firstQuestion(), firstQuestion)
        
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            []
        }
        XCTAssertNil(interactor.firstQuestion())
    }
    
    func testLastQuestion() {
        XCTAssertEqual(interactor.lastQuestion(), lastQuestion)
        
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            []
        }
        XCTAssertNil(interactor.lastQuestion())
    }
    
    func testGetIndex() {
        XCTAssertEqual(interactor.getIndex(of: firstQuestion), 0)
        XCTAssertEqual(interactor.getIndex(of: secondQuestion), 1)
        XCTAssertEqual(interactor.getIndex(of: lastQuestion), 2)
        XCTAssertNil(interactor.getIndex(of: .init(body: "存在しない質問", group: .init(name: "default"))))
    }
    
    func testGetTotalQuestionCount() {
        XCTAssertEqual(interactor.getTotalQuestionCount(), 3)
    }
    
    func testGetTime() {
        XCTAssertEqual(interactor.getTime(), 10)
    }
}
