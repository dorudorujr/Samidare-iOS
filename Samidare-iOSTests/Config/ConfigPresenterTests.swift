//
//  ConfigPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import XCTest
@testable import Samidare_iOS

class ConfigPresenterTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryMock!
    private var presenter: ConfigPresenter!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        appConfigRepositoryMock.getHandler = {
            .init(gameType: .init(name: "gameType"),
                  questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }
    }
    
    func testGetAppConfig() {
        Task {
            presenter = await .init(interactor: .init(appConfigRepository: appConfigRepositoryMock), router: .init())
            var questionGroup = await presenter.questionGroup
            XCTAssertNil(questionGroup)
            var playTime = await presenter.playTime
            XCTAssertNil(playTime)
            var gameType = await presenter.gameType
            XCTAssertNil(gameType)
            await presenter.getAppConfig()
            questionGroup = await presenter.questionGroup
            XCTAssertEqual(questionGroup, "questionGroup")
            gameType = await presenter.gameType
            XCTAssertEqual(gameType, "gameType")
            playTime = await presenter.playTime
            XCTAssertEqual(playTime, "1")
        }
    }
}
