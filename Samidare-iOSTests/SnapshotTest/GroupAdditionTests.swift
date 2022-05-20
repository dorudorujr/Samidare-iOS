//
//  GroupAdditionTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/04/23.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare_iOS

class GroupAdditionTests: XCTestCase {
    private var questionGroupRepositoryMock: QuestionGroupRepositoryMock!
    private var presenter: GroupAdditionPresenter!

    override func setUp() async throws {
        try await super.setUp()
        isRecording = false
        questionGroupRepositoryMock = .init()
        questionGroupRepositoryMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
        presenter = await .init(interactor: .init(questionGroupRepository: questionGroupRepositoryMock), router: .init())
    }

    func testStandard() {
        let view = GroupAdditionView(presenter: presenter)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhoneXsMax, precision: 0.95))
    }
}
