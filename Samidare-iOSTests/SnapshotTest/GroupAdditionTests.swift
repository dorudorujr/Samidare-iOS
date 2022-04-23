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
        isRecording = true
        questionGroupRepositoryMock = .init()
        questionGroupRepositoryMock.getHandler = {
            [
                .init(name: "デフォルト（テスト）")
            ]
        }
        presenter = await .init(interactor: .init(questionGroupRepository: questionGroupRepositoryMock))
    }
    
    func testStandard() {
        let view = GroupAdditionView(presenter: presenter)
        let test = ""
        print(test)
        assertSnapshot(matching: view.referenceFrame(), as: .image)
    }
}
