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

class ConfigViewTests: XCTestCase {
    private var presenter: ConfigPresenter<AppConfigRepositoryProtocolMock>!

    override func setUp() async throws {
        try await super.setUp()
        isRecording = false

        AppConfigRepositoryProtocolMock.getHandler = {
            .init(gameType: .init(name: "gameType"),
                  questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }

        presenter = await .init(interactor: .init(), router: .init())
    }

    func testConfigViewTestStandard() {
        let view = ConfigView<AppConfigRepositoryProtocolMock>(presenter: presenter)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhoneXsMax, precision: 0.95))
    }
}
