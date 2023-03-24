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
    private let questionGroup = QuestionGroup(name: "default")
    
    override func setUp() async throws {
        try await super.setUp()
        isRecording = false
        questionRepositoryMock.getQuestionsOfHandler = { _ in
            [
                .init(body: "八岐大蛇輪廻転生起承転結", group: self.questionGroup)
            ]
        }
    }
    
    func testQuestionAdditionViewStandard() {
        let store = withDependencies {
            $0.questionRepository = questionRepositoryMock
        } operation: {
            StoreOf<QuestionAdditionReducer>(initialState: .init(questionGroup: questionGroup),
                    reducer: QuestionAdditionReducer())
        }
        let view = QuestionAdditionView(store: store)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
