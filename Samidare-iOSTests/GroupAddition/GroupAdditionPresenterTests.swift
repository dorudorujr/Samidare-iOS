//
//  GroupAdditionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/19.
//

import XCTest
import SwiftUI
@testable import Samidare_iOS

class GroupAdditionPresenterTests: XCTestCase {
    private let questionGroup = QuestionGroup(name: "デフォルト（テスト）")
    
    override func setUp() {
        super.setUp()
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                self.questionGroup
            ]
        }
    }
    
    func testInit() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        let group = await presenter.groups!.first!
        XCTAssertEqual(group, questionGroup)
    }
    
    func testAddQuestionGroup() async {
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: .init())
        QuestionGroupRepositoryProtocolMock.addHandler = { questionGroup in
            XCTAssertEqual(questionGroup.name, "")
        }
        let addCallCountBefore = QuestionGroupRepositoryProtocolMock.addCallCount
        let getCallCountBefore = QuestionGroupRepositoryProtocolMock.getCallCount
        await presenter.addQuestionGroup()
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.addCallCount, addCallCountBefore + 1)
        XCTAssertEqual(QuestionGroupRepositoryProtocolMock.getCallCount, getCallCountBefore + 1)
        
        // 存在するグループ名の場合alertを表示するのでisShowingQuestionGroupUniqueErrorAlertがtrueになっているのか確認する
        QuestionGroupRepositoryProtocolMock.addHandler = { _ in
            throw QuestionGroupUniqueError()
        }
        var isShowingQuestionGroupUniqueErrorAlert = await presenter.isShowingQuestionGroupUniqueErrorAlert
        XCTAssertFalse(isShowingQuestionGroupUniqueErrorAlert)
        await presenter.addQuestionGroup()
        isShowingQuestionGroupUniqueErrorAlert = await presenter.isShowingQuestionGroupUniqueErrorAlert
        XCTAssertTrue(isShowingQuestionGroupUniqueErrorAlert)
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
    
    func testQuestionAdditionLinkBuilder() async {
        let router = await GroupAdditionRouter()
        let presenter = await GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>(interactor: .init(), router: router)
        let someView = await presenter.questionAdditionLinkBuilder(group: .init(name: "デフォルト")) {} as? NavigationLink<EmptyView, QuestionAdditionView<QuestionRepositoryImpl>>
        XCTAssertNotNil(someView)
    }
}
