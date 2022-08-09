//
//  QuestionListPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionListPresenterTests: XCTestCase {
    private let question = Question(body: "好きな色は", group: .init(name: "default"))
    
    override func setUp() {
        super.setUp()
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                self.question
            ]
        }
    }
    
    func testInit() {
        let presenter = QuestionListPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: "デフォルト")
        XCTAssertEqual(presenter.questions![0], question)
    }
}
