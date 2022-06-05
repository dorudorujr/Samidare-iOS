//
//  QuestionAdditionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionAdditionInteractorTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryProtocolMock!
    private var interactor: QuestionAdditionInteractor<QuestionRepositoryProtocolMock>!

    override func setUp() {
        super.setUp()
        questionRepositoryMock = .init()
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
        interactor = .init()
    }
    
    func testGetQuestions() {
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].body, "好きな色は")
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].group.name, "default")
    }
    
    func testAdd() {
        XCTAssertEqual(QuestionRepositoryProtocolMock.addCallCount, 0)
        try! interactor.add(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.addCallCount, 1)
    }
    
    func testUpdate() {
        XCTAssertEqual(QuestionRepositoryProtocolMock.updateCallCount, 0)
        try! interactor.update(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.updateCallCount, 1)
    }
    
    func testDelete() {
        XCTAssertEqual(QuestionRepositoryProtocolMock.deleteCallCount, 0)
        try! interactor.delete(.init(body: "テスト中？", group: .init(name: "default")))
        XCTAssertEqual(QuestionRepositoryProtocolMock.deleteCallCount, 1)
    }
}
