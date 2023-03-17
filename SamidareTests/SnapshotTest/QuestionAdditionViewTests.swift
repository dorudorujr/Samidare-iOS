//
//  QuestionAdditionViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import Samidare
import SwiftUI

class QuestionAdditionViewTests: XCTestCase {
    private let questionRepositoryMock = QuestionRepositoryProtocolMock()
    
    override func setUp() async throws {
        try await super.setUp()
        isRecording = true
        questionRepositoryMock.getQuestionsOfHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "好きな食べ物は", group: .init(name: "default")),
                .init(body: "誕生日は", group: .init(name: "default"))
            ]
        }
    }
    
    func testQuestionAdditionViewStandard() {
        let store = withDependencies {
            $0.questionRepository = questionRepositoryMock
        } operation: {
            StoreOf<QuestionAdditionReducer>(initialState: QuestionAdditionReducer.State(questionGroup: .init(name: "Test")),
                    reducer: QuestionAdditionReducer())
        }
        let view = QuestionAdditionView(store: store)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
