//
//  GroupAdditionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/19.
//

import XCTest
@testable import Samidare_iOS

class GroupAdditionPresenterTests: XCTestCase {
    private var questionGroupRepositoryMock: QuestionGroupRepositoryProtocolMock!
    
    override func setUp() {
        super.setUp()
        questionGroupRepositoryMock = .init()
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
    }
    
    func testInit() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        let group = await presenter.groups!.first!
        XCTAssertEqual(group.name, "デフォルト（テスト）")
    }
    
    func testAddQuestionGroup() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        QuestionGroupRepositoryProtocolMock.addHandler = { questionGroup in
            XCTAssertEqual(questionGroup.name, "")
        }
        let addCallCountBefore = QuestionGroupRepositoryProtocolMock.addCallCount
        await presenter.addQuestionGroup()
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.addCallCount, addCallCountBefore + 1)
    }
    
    func testDidTapNavBarButton() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        var isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertFalse(isShowingAddAlert)
        await presenter.didTapNavBarButton()
        isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertTrue(isShowingAddAlert)
    }
    
    func testDeleteGroup() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        QuestionGroupRepositoryProtocolMock.deleteHandler = { questionGroup in
            XCTAssertEqual(questionGroup.name, "デフォルト（テスト）")
        }
        var groups = await presenter.groups
        XCTAssertFalse(groups!.isEmpty)
        let deleteCallCountBefore = QuestionGroupRepositoryProtocolMock.deleteCallCount
        await presenter.deleteGroup(on: .init(integer: 0))
        groups = await presenter.groups
        XCTAssertTrue(groups!.isEmpty)
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.deleteCallCount, deleteCallCountBefore + 1)
    }
}
