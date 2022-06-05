//
//  AppConfigRepositoryTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/20.
//

import XCTest
import RealmSwift
@testable import Samidare_iOS

class AppConfigRepositoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testGetAndUpdate() {
        let updateAppConfig = AppConfig(gameType: .init(name: "gameType"),
                                        questionGroup: .init(name: "questionGroup"),
                                        time: 10)
        try! AppConfigRepositoryImpl.update(updateAppConfig)
        let getAppConfig = AppConfigRepositoryImpl.get()
        XCTAssertEqual(getAppConfig.id, updateAppConfig.id)
        XCTAssertEqual(getAppConfig.gameType.name, updateAppConfig.gameType.name)
        XCTAssertEqual(getAppConfig.questionGroup.name, updateAppConfig.questionGroup.name)
        XCTAssertEqual(getAppConfig.time, updateAppConfig.time)
    }
}
