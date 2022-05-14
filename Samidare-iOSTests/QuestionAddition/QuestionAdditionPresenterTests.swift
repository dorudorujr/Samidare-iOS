//
//  QuestionAdditionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionAdditionPresenterTests: XCTestCase {
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
    
    func testInit() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        let question = await presenter.questions![0]
        XCTAssertEqual(question.body, "好きな色は")
        XCTAssertEqual(question.group.name, "default")
    }
    
    func testAddQuestion() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        questionRepositoryMock.addHandler = { question in
            XCTAssertEqual(question.body, "")
        }
        XCTAssertEqual(questionRepositoryMock.addCallCount, 0)
        XCTAssertEqual(questionRepositoryMock.getQuestionsCallCount, 1)
        await presenter.addQuestion()
        XCTAssertEqual(questionRepositoryMock.addCallCount, 1)
        XCTAssertEqual(questionRepositoryMock.getQuestionsCallCount, 2)
    }
    
    func testUpdateQuestion() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        let questionToUpdate = Question(body: "Update", group: .init(name: "default"))
        await presenter.didTapList(question: questionToUpdate)
        questionRepositoryMock.updateHandler = { question in
            XCTAssertEqual(question.id, questionToUpdate.id)
            XCTAssertEqual(question.body, questionToUpdate.body)
            XCTAssertEqual(question.group.name, questionToUpdate.group.name)
        }
        XCTAssertEqual(questionRepositoryMock.updateCallCount, 0)
        XCTAssertEqual(questionRepositoryMock.getQuestionsCallCount, 1)
        await presenter.updateQuestion()
        XCTAssertEqual(questionRepositoryMock.updateCallCount, 1)
        XCTAssertEqual(questionRepositoryMock.getQuestionsCallCount, 2)
    }
    
    func testDeleteQuestion() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        let deleteQuestion = await presenter.questions![0]
        questionRepositoryMock.deleteHandler = { question in
            XCTAssertEqual(question.id, deleteQuestion.id)
            XCTAssertEqual(question.body, deleteQuestion.body)
            XCTAssertEqual(question.group.name, deleteQuestion.group.name)
        }
        await presenter.deleteQuestion(on: .init(integer: 0))
    }
    
    func testDidTapNavBarButton() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        var isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertFalse(isShowingAddAlert)
        await presenter.didTapNavBarButton()
        isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertTrue(isShowingAddAlert)
    }
    
    func testDidTapList() async {
        let presenter = await QuestionAdditionPresenter(interactor: .init(questionRepository: questionRepositoryMock), group: "default")
        var isShowingUpdateAlert = await presenter.isShowingUpdateAlert
        var updateQuestionBody = await presenter.updateQuestionBody
        XCTAssertFalse(isShowingUpdateAlert)
        XCTAssertEqual(updateQuestionBody, "")
        await presenter.didTapList(question: .init(body: "テスト中？", group: .init(name: "default")))
        isShowingUpdateAlert = await presenter.isShowingUpdateAlert
        updateQuestionBody = await presenter.updateQuestionBody
        XCTAssertTrue(isShowingUpdateAlert)
        XCTAssertEqual(updateQuestionBody, "テスト中？")
    }
}
