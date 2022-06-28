//
//  ConfigPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import XCTest
@testable import Samidare_iOS

class ConfigPresenterTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryProtocolMock!
    private var presenter: ConfigPresenter<AppConfigRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }
    }
    
    func testGetAppConfig() {
        Task {
            presenter = await .init(interactor: .init(), router: .init())
            var questionGroup = await presenter.questionGroup
            XCTAssertNil(questionGroup)
            var playTime = await presenter.playTime
            XCTAssertNil(playTime)
            await presenter.getAppConfig()
            questionGroup = await presenter.questionGroup
            XCTAssertEqual(questionGroup, "questionGroup")
            playTime = await presenter.playTime
            XCTAssertEqual(playTime, "1")
        }
    }
}
