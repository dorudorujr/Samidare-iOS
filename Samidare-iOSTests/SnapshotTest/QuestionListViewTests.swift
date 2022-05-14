//
//  QuestionListViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
import SnapshotTesting
@testable import Samidare_iOS
import SwiftUI

class QuestionListViewTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryMock!
    private var questionListPresenter: QuestionListPresenter!
    
    override func setUp() {
        super.setUp()
        isRecording = true
        questionRepositoryMock = .init()
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default")),
                .init(body: "好きな食べ物は", group: .init(name: "default")),
                .init(body: "誕生日は", group: .init(name: "default"))
            ]
        }
        questionListPresenter = .init(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
    }
    
    func testQuestionListViewStandard() {
        let questionListView = QuestionListView(presenter: questionListPresenter)
        let vc = UIHostingController(rootView: questionListView)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhoneXsMax, precision: 0.7))
    }

}
