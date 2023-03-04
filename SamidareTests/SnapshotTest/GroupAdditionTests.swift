//
//  GroupAdditionTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/23.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare

class GroupAdditionTests: XCTestCase {
    private var questionGroupRepositoryMock: QuestionGroupRepositoryProtocolMock!
    private var presenter: GroupAdditionPresenter<QuestionGroupRepositoryProtocolMock>!

    override func setUp() async throws {
        try await super.setUp()
        isRecording = false
        questionGroupRepositoryMock = .init()
        QuestionGroupRepositoryProtocolMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
        presenter = await .init(interactor: .init(), router: .init())
    }

    func testStandard() {
        let view = GroupAdditionView<QuestionGroupRepositoryProtocolMock>(presenter: presenter)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
