//
//  AppConfigSelectionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/06/27.
//

import XCTest
@testable import Samidare_iOS

class AppConfigSelectionPresenterTests: XCTestCase {
    private let questionGroup: QuestionGroup = .init(name: "デフォルト")
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "デフォルト"),
                  time: 10)
        }
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                self.questionGroup
            ]
        }
    }
    
    func testInit() async {
        // type = .questionGroup
        var presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .questionGroup)
        let questionGroup = await presenter.questionGroups![0]
        XCTAssertEqual(questionGroup, self.questionGroup)
        
        // type = .gameTime
        presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .gameTime)
        let appConfigGameTime = await presenter.appConfigGameTime
        XCTAssertEqual(appConfigGameTime, 10)
    }
    
    // typeが.questionGroup
    func testFetchQuestionGroupsOfQuestionGroup() async {
        // type = .questionGroup
        let presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .questionGroup)
        var questionGroup = await presenter.questionGroups![0]
        XCTAssertEqual(questionGroup, self.questionGroup)
        let updateGroup = QuestionGroup(name: "Test")
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                updateGroup
            ]
        }
        await presenter.fetchQuestionGroups()
        questionGroup = await presenter.questionGroups![0]
        XCTAssertEqual(questionGroup, updateGroup)
    }
    
    // typeが.gameTime
    func testFetchQuestionGroupsOfGameTime() async {
        // type = .questionGroup
        let presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .gameTime)
        var questionGroups = await presenter.questionGroups
        XCTAssertNil(questionGroups)
        let updateGroup = QuestionGroup(name: "Test")
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                updateGroup
            ]
        }
        await presenter.fetchQuestionGroups()
        questionGroups = await presenter.questionGroups
        XCTAssertNil(questionGroups)
    }
    
    func testUpdateQuestionGroup() async {
        let presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .questionGroup)
        var questionGroup = await presenter.questionGroups![0]
        // initで取得した値か確認
        XCTAssertEqual(questionGroup, self.questionGroup)
        AppConfigRepositoryProtocolMock.updateHandler = { appConfig in
            // Presenterのupdateの引数の値で更新されているか確認
            XCTAssertEqual(appConfig.questionGroup.name, "Update Test")
        }
        let updateGroup = QuestionGroup(name: "Test")
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                updateGroup
            ]
        }
        await presenter.update(questionGroup: "Update Test")
        questionGroup = await presenter.questionGroups![0]
        // Repositoryのgetを呼び出してPresenterのquestionGroupsが更新されているか確認
        XCTAssertEqual(questionGroup, updateGroup)
    }
    
    func testUpdateGameTime() async {
        let presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .gameTime)
        var appConfigGameTime = await presenter.appConfigGameTime
        // initで取得したappConfigGameTimeか確認
        XCTAssertEqual(appConfigGameTime, 10)
        
        let updateAppConfig = AppConfig(questionGroup: .init(name: "Update"),
                                        time: 20)
        AppConfigRepositoryProtocolMock.getHandler = {
            updateAppConfig
        }
        AppConfigRepositoryProtocolMock.updateHandler = { appConfig in
            // Presenterのupdateの引数の値で更新されているか確認
            XCTAssertEqual(appConfig.time, 60)
        }
        await presenter.update(gameTime: 60)
        appConfigGameTime = await presenter.appConfigGameTime
        // Repositoryのgetを呼び出してPresenterのappConfigGameTimeが更新されているか確認
        XCTAssertEqual(appConfigGameTime, 20)
    }
    
    func testIsSelectedQuestionGroup() async {
        let presenter = await AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .gameTime)
        // true
        var isSelectedQuestionGroup = await presenter.isSelectedQuestionGroup(questionGroup: .init(name: "デフォルト"))
        XCTAssertTrue(isSelectedQuestionGroup)
        
        // false
        isSelectedQuestionGroup = await presenter.isSelectedQuestionGroup(questionGroup: .init(name: "false"))
        XCTAssertFalse(isSelectedQuestionGroup)
    }
}
