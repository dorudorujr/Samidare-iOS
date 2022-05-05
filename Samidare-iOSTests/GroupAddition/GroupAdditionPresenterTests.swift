//
//  GroupAdditionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/19.
//

import XCTest
@testable import Samidare_iOS

class GroupAdditionPresenterTests: XCTestCase {
    private var questionGroupRepositoryMock: QuestionGroupRepositoryMock!
    
    override func setUp() {
        super.setUp()
        questionGroupRepositoryMock = .init()
        questionGroupRepositoryMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
    }
    
    func testInit() async {
        let presenter = await GroupAdditionPresenter(interactor: .init(questionGroupRepository: questionGroupRepositoryMock), router: .init())
        let group = await presenter.groups!.first!
        XCTAssertEqual(group.name, "デフォルト（テスト）")
    }
    
    func testAddQuestionGroup() async {
        let presenter = await GroupAdditionPresenter(interactor: .init(questionGroupRepository: questionGroupRepositoryMock), router: .init())
        questionGroupRepositoryMock.addHandler = { questionGroup in
            XCTAssertEqual(questionGroup.name, "")
        }
        await presenter.addQuestionGroup()
        XCTAssertEqual(questionGroupRepositoryMock.addCallCount, 1)
    }
    
    func testDidTapNavBarButton() async {
        let presenter = await GroupAdditionPresenter(interactor: .init(questionGroupRepository: questionGroupRepositoryMock), router: .init())
        var isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertFalse(isShowingAddAlert)
        await presenter.didTapNavBarButton()
        isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertTrue(isShowingAddAlert)
    }
    
    func testDeleteGroup() async {
        let presenter = await GroupAdditionPresenter(interactor: .init(questionGroupRepository: questionGroupRepositoryMock), router: .init())
        questionGroupRepositoryMock.deleteHandler = { questionGroup in
            XCTAssertEqual(questionGroup.name, "デフォルト（テスト）")
        }
        var groups = await presenter.groups
        XCTAssertFalse(groups!.isEmpty)
        await presenter.deleteGroup(on: .init(integer: 0))
        groups = await presenter.groups
        XCTAssertTrue(groups!.isEmpty)
        XCTAssertEqual(questionGroupRepositoryMock.deleteCallCount, 1)
    }
}
