//
//  GroupAdditionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/19.
//

import XCTest
@testable import Samidare

class GroupAdditionInteractorTests: XCTestCase {
    private var interactor: GroupAdditionInteractor<QuestionGroupRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
        interactor = .init()
    }
    
    func testGetQuestionGroup() {
        let questionGroup = interactor.getQuestionGroup()
        XCTAssertEqual(questionGroup[0].name, "デフォルト（テスト）")
    }
    
    func testAdd() {
        let beforeAddCallCount = QuestionGroupRepositoryProtocolMock.addCallCount
        try! interactor.add(.init(name: "test"))
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.addCallCount, beforeAddCallCount + 1)
    }
    
    func testDelete() {
        let beforeDeleteCallCount = QuestionGroupRepositoryProtocolMock.deleteCallCount
        try! interactor.delete(.init(name: "test"))
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.deleteCallCount, beforeDeleteCallCount + 1)
    }
}
