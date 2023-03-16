//
//  QuestionViewTests.swift
//  Samidare-iOSUITests
//
//  Created by 杉岡成哉 on 2022/02/12.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Samidare

class QuestionViewTests: XCTestCase {
    private let question = Question(body: "好きな色は", group: .init(name: "default"))
    private let readyCountDownTime: Double = 3.0

    override func setUp() {
        super.setUp()
        isRecording = false
    }

    func testStandBy() {
        let state = QuestionReducer.State(status: .standBy)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }

    func testReady() {
        let state = QuestionReducer.State(question: question, status: .ready, nowTime: readyCountDownTime)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }
    
    func testStopReadying() {
        let state = QuestionReducer.State(question: question, status: .stopReadying, nowTime: readyCountDownTime)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }
    
    func testPlay() {
        let state = QuestionReducer.State(questionCountText: "1/1",question: question, status: .play, nowTime: 7.0, totalPlayTime: 10)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }
    
    func testStopPlaying() {
        let state = QuestionReducer.State(questionCountText: "1/1",question: question, status: .stopPlaying, nowTime: 7.0, totalPlayTime: 10)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }
    
    func testDone() {
        let state = QuestionReducer.State(questionCountText: "1/1",question: question, status: .done, nowTime: 7.0, totalPlayTime: 10)
        let questionView = QuestionView(store: .init(initialState: state,
                                                     reducer: QuestionReducer()))
        let vc = UIHostingController(rootView: questionView)
        assertSnapshot(matching: vc,
                       as: .image(on: .iPhone13ProMax, precision: 0.996))
    }
}
