//
//  QuestionListPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionListPresenterTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryMock!
    
    override func setUp() {
        super.setUp()
        questionRepositoryMock = .init()
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
    }
    
    func testInit() {
        let presenter = QuestionListPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "デフォルト")
        XCTAssertEqual(presenter.questions![0].body, "好きな色は")
        XCTAssertEqual(presenter.questions![0].group.name, "default")
    }
}
