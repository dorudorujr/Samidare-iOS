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
        presenter = .init(interactor: .init(appConfigRepository: appConfigRepositoryMock))
    }
    
    func testGetAppConfig() {
        XCTAssertNil(presenter.questionGroup)
        XCTAssertNil(presenter.playTime)
        XCTAssertNil(presenter.gameType)
        presenter.getAppConfig()
        XCTAssertEqual(presenter.questionGroup, "questionGroup")
        XCTAssertEqual(presenter.gameType, "gameType")
        XCTAssertEqual(presenter.playTime, "1")
    }
}
