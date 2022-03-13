//
//  ConfigInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import XCTest
@testable import Samidare_iOS

class ConfigInteractorTests: XCTestCase {
    private var appConfigRepositoryMock: AppConfigRepositoryMock!
    private var interactor: ConfigInteractor!
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock = .init()
        appConfigRepositoryMock.getHandler = {
            .init(gameType: .init(name: "gameType"),
                  questionGroup: .init(name: "questionGroup"),
                  time: 10)
        }
        interactor = .init(appConfigRepository: appConfigRepositoryMock)
    }
    
    func testGetAppConfig() {
        XCTAssertEqual(interactor.getAppConfig().gameType.name, "gameType")
        XCTAssertEqual(interactor.getAppConfig().questionGroup.name, "questionGroup")
        XCTAssertEqual(interactor.getAppConfig().time, 10)
    }
}
