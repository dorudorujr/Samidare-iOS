//
//  QuestionAdditionReducerTests.swift
//  SamidareTests
//
//  Created by 杉岡成哉 on 2023/03/19.
//

import XCTest
import ComposableArchitecture

@testable import Samidare

@MainActor
final class QuestionAdditionReducerTests: XCTestCase {
    private var store: TestStore<QuestionAdditionReducer.State, QuestionAdditionReducer.Action, QuestionAdditionReducer.State, QuestionAdditionReducer.Action, ()>!
    private let questionRepositoryMock = QuestionRepositoryProtocolMock()
    private let group = QuestionGroup(name: "QuestionAdditionReducerTests")
    private lazy var questions: [Question] = [
        .init(body: "好きな色", group: group)
    ]
    
    override func setUp() {
        super.setUp()
        questionRepositoryMock.getQuestionsOfHandler = { _ in
            self.questions
        }
        store = makeStore(state: QuestionAdditionReducer.State(questionGroup: group))
    }
    
    func testOnAppear() async {
        XCTAssertNil(store.state.questions)
        
        await store.send(.onAppear) {
            $0.questions = self.questions
        }
    }
    
    func testAddQuestionSuccess() async {
        let state = QuestionAdditionReducer.State(questionGroup: group, addQuestionBody: "testAddQuestionSuccess")
        store = makeStore(state: state)
        XCTAssertNil(store.state.questions)
        
        questionRepositoryMock.addQuestionHandler = { question in
            XCTAssertEqual(question.body, "testAddQuestionSuccess")
            XCTAssertEqual(question.group, self.group)
        }
        
        await store.send(.addQuestion) {
            $0.questions = self.questions
        }
        XCTAssertEqual(questionRepositoryMock.addQuestionCallCount, 1)
    }
    
    func testAddQuestionFailure() async {
        XCTAssertNil(store.state.questions)
        XCTAssertNil(store.state.errorAlert)
        
        questionRepositoryMock.addQuestionHandler = { _ in
            throw NSError()
        }
        await store.send(.addQuestion) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertEqual(questionRepositoryMock.addQuestionCallCount, 1)
        XCTAssertNil(store.state.questions)
    }
    
    func testUpdateSuccess() async {
        XCTAssertNil(store.state.questions)
        let questionToUpdate = Question(body: "questionToUpdate", group: group)
        let state = QuestionAdditionReducer.State(questionGroup: group, updateQuestionBody: "testUpdateSuccess", questionToUpdate: questionToUpdate)
        store = makeStore(state: state)
        XCTAssertNil(store.state.questions)
        
        questionRepositoryMock.updateQuestionHandler = { question in
            XCTAssertEqual(question.id, questionToUpdate.id)
            XCTAssertEqual(question.body, "testUpdateSuccess")
            XCTAssertEqual(question.group, self.group)
        }
        await store.send(.update) {
            $0.questions = self.questions
        }
        XCTAssertEqual(questionRepositoryMock.updateQuestionCallCount, 1)
    }
    
    func testUpdateFailure() async {
        let questionToUpdate = Question(body: "questionToUpdate", group: group)
        let state = QuestionAdditionReducer.State(questionGroup: group, updateQuestionBody: "testUpdateSuccess", questionToUpdate: questionToUpdate)
        store = makeStore(state: state)
        XCTAssertNil(store.state.questions)
        XCTAssertNil(store.state.errorAlert)
        
        questionRepositoryMock.updateQuestionHandler = { _ in
            throw NSError()
        }
        await store.send(.update) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertEqual(questionRepositoryMock.updateQuestionCallCount, 1)
        XCTAssertNil(store.state.questions)
    }
    
    func testDeleteSuccess() async {
        let deleteQuestion = Question(body: "delete Question", group: group)
        let state = QuestionAdditionReducer.State(questionGroup: group, questions: [
            .init(body: "好きな色", group: group),
            deleteQuestion
        ])
        store = makeStore(state: state)
        
        questionRepositoryMock.deleteQuestionHandler = { question in
            XCTAssertEqual(question, deleteQuestion)
        }
        await store.send(.delete(index: .init(integer: 1))) {
            $0.questions = self.questions
        }
        
        XCTAssertEqual(questionRepositoryMock.deleteQuestionCallCount, 1)
    }
    
    func testDeleteFailure() async {
        let deleteQuestion = Question(body: "delete Question", group: group)
        let state = QuestionAdditionReducer.State(questionGroup: group, questions: [
            .init(body: "好きな色", group: group),
            deleteQuestion
        ])
        store = makeStore(state: state)
        
        XCTAssertNil(store.state.errorAlert)
        
        questionRepositoryMock.deleteQuestionHandler = { _ in
            throw NSError()
        }
        await store.send(.delete(index: .init(integer: 0))) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertEqual(questionRepositoryMock.deleteQuestionCallCount, 1)
    }
    
    func testDidTapList() async {
        let question = Question(body: "testDidTapList", group: group)
        
        await store.send(.didTapList(question: question)) {
            $0.updateQuestionBody = question.body
            $0.isShowingUpdateAlert = true
            $0.questionToUpdate = question
        }
    }
    
    func testAlertDismissed() async {
        await store.send(.alertDismissed)
    }
    
    func testDidTapNavBarButton() async {
        await store.send(.didTapNavBarButton) {
            $0.isShowingAddAlert = true
        }
    }
    
    func testDidTapListRow() async {
        await store.send(.didTapListRow) {
            $0.isShowingUpdateAlert = true
        }
    }
    
    private func makeStore(state: QuestionAdditionReducer.State) -> TestStore<QuestionAdditionReducer.State, QuestionAdditionReducer.Action, QuestionAdditionReducer.State, QuestionAdditionReducer.Action, ()> {
        withDependencies {
            $0.questionRepository = questionRepositoryMock
        } operation: {
            TestStore(initialState: state,
                      reducer: QuestionAdditionReducer())
        }
    }
}
