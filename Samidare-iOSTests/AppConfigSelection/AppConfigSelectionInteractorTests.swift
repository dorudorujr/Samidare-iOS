//
//  AppConfigSelectionInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/06/21.
//

import XCTest
@testable import Samidare_iOS

class AppConfigSelectionInteractorTests: XCTestCase {
    private let appConfig: AppConfig = .init(gameType: .init(name: "デフォルト"),
                                             questionGroup: .init(name: "デフォルト"),
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
    
    func testUpdateQuestionGroup() {
        AppConfigRepositoryProtocolMock.updateHandler = { updateAppConfig in
            XCTAssertEqual(self.appConfig.id, updateAppConfig.id)
            XCTAssertEqual(updateAppConfig.questionGroup.name, "更新Test")
        }
        try! interactor.update(questionGroup: "更新Test")
    }
    
    func testUpdateGameTime() {
        AppConfigRepositoryProtocolMock.updateHandler = { updateAppConfig in
            XCTAssertEqual(self.appConfig.id, updateAppConfig.id)
            XCTAssertEqual(updateAppConfig.time, 60)
        }
        try! interactor.update(gameTime: 60)
    }
}
