//
//  GroupAdditionTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/23.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import Samidare
import SwiftUI

class GroupAdditionTests: XCTestCase {
    private var questionGroupRepositoryMock = QuestionGroupRepositoryProtocolMock()

    override func setUp() async throws {
        try await super.setUp()
        isRecording = false
        questionGroupRepositoryMock.getQuestionGroupHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
    }

    func testStandard() {
        let store = withDependencies {
            $0.questionGroupRepository = questionGroupRepositoryMock
        } operation: {
            StoreOf<GroupAdditionReducer>(initialState: GroupAdditionReducer.State(),
                    reducer: GroupAdditionReducer())
        }
        let view = GroupAdditionView(store: store)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
