//
//  QuestionListInteractorTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/13.
//

import XCTest
@testable import Samidare_iOS

class QuestionListInteractorTests: XCTestCase {
    private var interactor: QuestionListInteractor<QuestionRepositoryProtocolMock>!
    private let question = Question(body: "好きな色は", group: .init(name: "default"))
    
    override func setUp() {
        super.setUp()
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                self.question
            ]
        }
        interactor = .init()
    }
    
    func testGetQuestion() {
        XCTAssertEqual(interactor.getQuestions(of: "デフォルト")[0], question)
    }
}
