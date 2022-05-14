//
//  QuestionAdditionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionAdditionInteractorTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryMock!
    private var interactor: QuestionAdditionInteractor!

    override func setUp() {
        super.setUp()
        questionRepositoryMock = .init()
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
        interactor = .init(questionRepository: questionRepositoryMock)
    }
    
    func testGetQuestions() {
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].body, "好きな色は")
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].group.name, "default")
    }
    
    func testAdd() {
        XCTAssertEqual(questionRepositoryMock.addCallCount, 0)
        try! interactor.add(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(questionRepositoryMock.addCallCount, 1)
    }
    
    func testUpdate() {
        XCTAssertEqual(questionRepositoryMock.updateCallCount, 0)
        try! interactor.update(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(questionRepositoryMock.updateCallCount, 1)
    }
    
    func testDelete() {
        XCTAssertEqual(questionRepositoryMock.deleteCallCount, 0)
        try! interactor.delete(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(questionRepositoryMock.deleteCallCount, 1)
    }
}
