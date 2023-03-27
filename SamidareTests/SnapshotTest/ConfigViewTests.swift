//
//  ConfigViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/07.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import Samidare
import SwiftUI

class ConfigViewTests: XCTestCase {
    private var appConfigRepositoryMock = AppConfigRepositoryProtocolMock()

    override func setUp() async throws {
        try await super.setUp()
        isRecording = false

        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "questionGroup",
                  time: 1)
        }
    }

    func testConfigViewTestStandard() {
        let store = withDependencies {
            $0.appConfigRepository = appConfigRepositoryMock
        } operation: {
            StoreOf<ConfigReducer>(initialState: .init(),
                    reducer: ConfigReducer())
        }
        let view = ConfigView(store: store)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
