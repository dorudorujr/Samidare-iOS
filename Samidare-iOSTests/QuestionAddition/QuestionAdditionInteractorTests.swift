//
//  QuestionAdditionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionAdditionInteractorTests: XCTestCase {
    private var interactor: QuestionAdditionInteractor<QuestionRepositoryProtocolMock>!
    private let question = Question(body: "好きな色は", group: .init(name: "default"))

    override func setUp() {
        super.setUp()
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                self.question
            ]
        }
        interactor = .init()
    }
    
    func testGetQuestions() {
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0], question)
    }
    
    func testAdd() {
        let beforeAddCallCount = QuestionRepositoryProtocolMock.addCallCount
        try! interactor.add(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.addCallCount, beforeAddCallCount + 1)
    }
    
    func testUpdate() {
        let beforeUpdateCallCount = QuestionRepositoryProtocolMock.updateCallCount
        try! interactor.update(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.updateCallCount, beforeUpdateCallCount + 1)
    }
    
    func testDelete() {
        let beforeDeleteCallCount = QuestionRepositoryProtocolMock.deleteCallCount
        try! interactor.delete(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.deleteCallCount, beforeDeleteCallCount + 1)
    }
}
