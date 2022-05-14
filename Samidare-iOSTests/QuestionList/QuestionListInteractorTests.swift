//
//  QuestionListInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/13.
//

import XCTest
@testable import Samidare_iOS

class QuestionListInteractorTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryMock!
    private var interactor: QuestionListInteractor!
    
    override func setUp() {
        super.setUp()
        questionRepositoryMock = .init()
        questionRepositoryMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
        interactor = .init(questionRepository: questionRepositoryMock)
    }
    
    func testGetQuestion() {
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].body, "好きな色は")
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0].group.name, "default")
    }
}
