//
//  AppConfigSelectionViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/06/28.
//

import XCTest
import SnapshotTesting
@testable import Samidare_iOS
import SwiftUI

class AppConfigSelectionViewTests: XCTestCase {
    override func setUp() {
        super.setUp()
        isRecording = false
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(gameType: .init(name: "デフォルト"),
                  questionGroup: .init(name: "デフォルト"),
                  time: 10)
        }
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                .init(name: "デフォルト")
            ]
        }
    }
    
    @MainActor
    func testQuestionGroupType() {
        let presenter = AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .questionGroup)
        let view = AppConfigSelectionView<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(presenter: presenter, description: AppConfigSelectionType.questionGroup.description)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhoneXsMax, precision: 0.95))
    }
    
    @MainActor
    func testGameTimeType() {
        let presenter = AppConfigSelectionPresenter<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(interactor: .init(), type: .gameTime)
        let view = AppConfigSelectionView<AppConfigRepositoryProtocolMock, QuestionGroupRepositoryProtocolMock>(presenter: presenter, description: AppConfigSelectionType.gameTime.description)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhoneXsMax, precision: 0.95))
    }
}
