//
//  GroupAdditionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/19.
//

import XCTest
@testable import Samidare_iOS

class GroupAdditionInteractorTests: XCTestCase {
    private var questionGroupRepositoryMock: QuestionGroupRepositoryMock!
    private var interactor: GroupAdditionInteractor!
    
    override func setUp() {
        super.setUp()
        questionGroupRepositoryMock = .init()
        questionGroupRepositoryMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
        interactor = .init(questionGroupRepository: questionGroupRepositoryMock)
    }
    
    func testGetQuestionGroup() {
        let questionGroup = interactor.getQuestionGroup()
        XCTAssertEqual(questionGroup[0].name, "デフォルト（テスト）")
    }
    
    func testAdd() {
        try! interactor.add(.init(name: "test"))
        XCTAssertEqual(questionGroupRepositoryMock.addCallCount, 1)
    }
    
    func testDelete() {
        try! interactor.delete(.init(name: "test"))
        XCTAssertEqual(questionGroupRepositoryMock.deleteCallCount, 1)
    }
}
