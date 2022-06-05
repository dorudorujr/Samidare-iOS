//
//  QuestionAdditionPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
@testable import Samidare_iOS

class QuestionAdditionPresenterTests: XCTestCase {
    private var questionRepositoryMock: QuestionRepositoryProtocolMock!
    
    override func setUp() {
        super.setUp()
        questionRepositoryMock = .init()
        QuestionRepositoryProtocolMock.getQuestionsHandler = { _ in
            [
                .init(body: "好きな色は", group: .init(name: "default"))
            ]
        }
    }
    
    func testInit() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
        let question = await presenter.questions![0]
        XCTAssertEqual(question.body, "好きな色は")
        XCTAssertEqual(question.group.name, "default")
    }
    
    func testAddQuestion() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
        QuestionRepositoryProtocolMock.addHandler = { question in
            XCTAssertEqual(question.body, "")
        }
        let addCallCountBefore = QuestionRepositoryProtocolMock.addCallCount
        let getQuestionsCallCountBefore = QuestionRepositoryProtocolMock.getQuestionsCallCount
        await presenter.addQuestion()
        XCTAssertEqual(QuestionRepositoryProtocolMock.addCallCount, addCallCountBefore + 1)
        XCTAssertEqual(QuestionRepositoryProtocolMock.getQuestionsCallCount, getQuestionsCallCountBefore + 1)
    }
    
    func testUpdateQuestion() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
        let questionToUpdate = Question(body: "Update", group: .init(name: "default"))
        await presenter.didTapList(question: questionToUpdate)
        QuestionRepositoryProtocolMock.updateHandler = { question in
            XCTAssertEqual(question.id, questionToUpdate.id)
            XCTAssertEqual(question.body, questionToUpdate.body)
            XCTAssertEqual(question.group.name, questionToUpdate.group.name)
        }
        let updateCallCountBefore = QuestionRepositoryProtocolMock.updateCallCount
        let getQuestionsCallCount = QuestionRepositoryProtocolMock.getQuestionsCallCount
        await presenter.updateQuestion()
        XCTAssertEqual(QuestionRepositoryProtocolMock.updateCallCount, updateCallCountBefore + 1)
        XCTAssertEqual(QuestionRepositoryProtocolMock.getQuestionsCallCount, getQuestionsCallCount + 1)
    }
    
    func testDeleteQuestion() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
        let deleteQuestion = await presenter.questions![0]
        QuestionRepositoryProtocolMock.deleteHandler = { question in
            XCTAssertEqual(question.id, deleteQuestion.id)
            XCTAssertEqual(question.body, deleteQuestion.body)
            XCTAssertEqual(question.group.name, deleteQuestion.group.name)
        }
        await presenter.deleteQuestion(on: .init(integer: 0))
    }
    
    func testDidTapNavBarButton() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
        var isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertFalse(isShowingAddAlert)
        await presenter.didTapNavBarButton()
        isShowingAddAlert = await presenter.isShowingAddAlert
        XCTAssertTrue(isShowingAddAlert)
    }
    
    func testDidTapList() async {
        let presenter = await QuestionAdditionPresenter<QuestionRepositoryProtocolMock>(interactor: .init(), group: .init(name: "default"))
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
