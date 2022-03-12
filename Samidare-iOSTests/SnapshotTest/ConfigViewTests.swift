//
//  ConfigViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/07.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare_iOS

//class ConfigViewTests: XCTestCase {
//    private var appConfigRepositoryMock: AppConfigRepositoryMock!
//    private var presenter: ConfigPresenter!
//
//    override func setUp() {
//        super.setUp()
//        isRecording = false
//
//        appConfigRepositoryMock = .init()
//        appConfigRepositoryMock.getHandler = {
//            .init(gameType: .init(name: "gameType"),
//                  questionGroup: .init(name: "questionGroup"),
//                  time: 1)
//        }
//
//        presenter = .init(interactor: .init(appConfigRepository: appConfigRepositoryMock))
//    }
//    
//    func testStandard() {
//        let view = ConfigView(presenter: presenter)
//        assertSnapshot(matching: view.referenceFrame(),
//                       as: .image)
//    }
//}
