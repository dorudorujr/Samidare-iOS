//
//  ConfigInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import XCTest
@testable import Samidare

class ConfigInteractorTests: XCTestCase {
    private var interactor: ConfigInteractor<AppConfigRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 10)
        }
        interactor = .init()
    }
    
    func testGetAppConfig() {
        XCTAssertEqual(interactor.getAppConfig().questionGroup.name, "questionGroup")
        XCTAssertEqual(interactor.getAppConfig().time, 10)
    }
}
