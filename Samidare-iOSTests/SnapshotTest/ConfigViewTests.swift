//
//  ConfigViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/07.
//

//import XCTest
//import SnapshotTesting
//import SwiftUI
//@testable import Samidare_iOS

//class ConfigViewTests: XCTestCase {
//    private var appConfigRepositoryMock: AppConfigRepositoryMock!
//    private var presenter: ConfigPresenter!
//
//    override func setUp() async throws {
//        try await super.setUp()
//        isRecording = false
//
//        appConfigRepositoryMock = .init()
//        appConfigRepositoryMock.getHandler = {
//            .init(gameType: .init(name: "gameType"),
//                  questionGroup: .init(name: "questionGroup"),
//                  time: 1)
//        }
//
//        presenter = await .init(interactor: .init(appConfigRepository: appConfigRepositoryMock), router: .init())
//    }
//
//    func testStandard() {
//        let view = ConfigView(presenter: presenter)
//        assertSnapshot(matching: view.referenceFrame(),
//                       as: .image(precision: 0.8))
//    }
//}
