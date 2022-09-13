//
//  AppConfigSelectionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/06/21.
//

import XCTest
@testable import Samidare_iOS

class AppConfigSelectionInteractorTests: XCTestCase {
    private let appConfig: AppConfig = .init(questionGroup: .init(name: "デフォルト"),
                                             time: 10)
    
    private var interactor: AppConfigSelectionInteractor<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            self.appConfig
        }
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                .init(name: "デフォルト")
            ]
        }
        interactor = .init()
    }
    
    func testQuestionGroups() {
        XCTAssertEqual(interactor.questionGroups()[0].name, "デフォルト")
    }
    
    func testGameTime() {
        XCTAssertEqual(interactor.gameTime(), 10)
    }
    
    func selectQuestionGroup() {
        XCTAssertEqual(interactor.selectQuestionGroup().name, "デフォルト")
    }
    
    func testUpdateQuestionGroup() {
        AppConfigRepositoryProtocolMock.updateHandler = { updateAppConfig in
            XCTAssertEqual(self.appConfig.id, updateAppConfig.id)
            XCTAssertNotEqual(self.appConfig.questionGroup, updateAppConfig.questionGroup)
            XCTAssertEqual(updateAppConfig.questionGroup.name, "更新Test")
        }
        try! interactor.update(questionGroup: .init(name: "更新Test"))
    }
    
    func testUpdateGameTime() {
        AppConfigRepositoryProtocolMock.updateHandler = { updateAppConfig in
            XCTAssertEqual(self.appConfig.id, updateAppConfig.id)
            XCTAssertNotEqual(self.appConfig.time, updateAppConfig.time)
            XCTAssertEqual(updateAppConfig.time, 60)
        }
        try! interactor.update(gameTime: 60)
    }
}
