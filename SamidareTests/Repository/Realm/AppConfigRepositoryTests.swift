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
        // ないグループだと何もしないのでグループを追加
        let group = QuestionGroup(name: "questionGroup")
        try! QuestionGroupRepositoryImpl.add(group)
        
        let updateAppConfig = AppConfig(questionGroup: group,
                                        time: 10)
        try! AppConfigRepositoryImpl.update(updateAppConfig)
        let getAppConfig = AppConfigRepositoryImpl.get()
        XCTAssertEqual(getAppConfig, updateAppConfig)
    }
}
