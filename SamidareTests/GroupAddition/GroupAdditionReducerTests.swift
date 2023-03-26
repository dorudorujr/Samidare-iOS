//
//  GroupAdditionReducerTests.swift
//  SamidareTests
//
//  Created by 杉岡成哉 on 2023/03/26.
//

import XCTest
import ComposableArchitecture

@testable import Samidare

@MainActor
final class GroupAdditionReducerTests: XCTestCase {
    typealias Store = TestStore<GroupAdditionReducer.State, GroupAdditionReducer.Action, GroupAdditionReducer.State, GroupAdditionReducer.Action, ()>
    private var store: Store!
    private let questionGroupRepositoryMock = QuestionGroupRepositoryProtocolMock()
    
    private let questionGroups: [QuestionGroup] = [
        .init(name: "GroupAdditionReducerTests")
    ]
    
    override func setUp() {
        super.setUp()
        questionGroupRepositoryMock.getQuestionGroupHandler = {
            self.questionGroups
        }
        store = makeStore(state: .init())
    }
    
    func testOnAppear() async {
        XCTAssertNil(store.state.groups)
        
        await store.send(.onAppear) {
            $0.groups = self.questionGroups
        }
    }
    
    func testAddQuestionGroupSuccess() async {
        let state = GroupAdditionReducer.State(addGroupBody: "testAddQuestionGroupSuccess")
        store = makeStore(state: state)
        
        questionGroupRepositoryMock.addQuestionGroupHandler = { group in
            XCTAssertEqual(group.name, "testAddQuestionGroupSuccess")
        }
        
        await store.send(.addQuestionGroup) {
            $0.groups = self.questionGroups
        }
        
        XCTAssertEqual(questionGroupRepositoryMock.addQuestionGroupCallCount, 1)
    }
    
    func testAddQuestionGroupFailure() async {
        // NSError
        questionGroupRepositoryMock.addQuestionGroupHandler = { _ in
            throw NSError(domain: "Test Error", code: -9999)
        }
        
        await store.send(.addQuestionGroup) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertNil(store.state.groups)
        
        // QuestionGroupUniqueError
        questionGroupRepositoryMock.addQuestionGroupHandler = { _ in
            throw QuestionGroupUniqueError()
        }
        
        await store.send(.addQuestionGroup) {
            $0.errorAlert = .init {
                TextState("")
            } message: {
                TextState(L10n.Error.Question.Group.unique)
            }
        }
        XCTAssertNil(store.state.groups)
    }
    
    func testUpdateSuccess() async {
        let groupToUpdate = QuestionGroup(name: "testUpdateSuccess before")
        let state = GroupAdditionReducer.State(groupToUpdate: groupToUpdate, updateGroupBody: "testUpdateSuccess after")
        store = makeStore(state: state)
        
        questionGroupRepositoryMock.addQuestionGroupHandler = { group in
            XCTAssertEqual(group.id, groupToUpdate.id)
            XCTAssertEqual(group.name, "testUpdateSuccess after")
        }
        
        await store.send(.update) {
            $0.groups = self.questionGroups
        }
        
        XCTAssertEqual(questionGroupRepositoryMock.addQuestionGroupCallCount, 1)
    }
    
    func testUpdateFailure() async {
        let groupToUpdate = QuestionGroup(name: "testUpdateSuccess before")
        let state = GroupAdditionReducer.State(groupToUpdate: groupToUpdate, updateGroupBody: "testUpdateSuccess after")
        store = makeStore(state: state)
        
        // NSError
        questionGroupRepositoryMock.addQuestionGroupHandler = { _ in
            throw NSError(domain: "Test Error", code: -9999)
        }
        
        await store.send(.update) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertNil(store.state.groups)
        
        // QuestionGroupUniqueError
        questionGroupRepositoryMock.addQuestionGroupHandler = { _ in
            throw QuestionGroupUniqueError()
        }
        
        await store.send(.update) {
            $0.errorAlert = .init {
                TextState("")
            } message: {
                TextState(L10n.Error.Question.Group.unique)
            }
        }
        XCTAssertNil(store.state.groups)
    }
    
    func testDeleteSuccess() async {
        let deleteGroup = QuestionGroup(name: "testDeleteSuccess")
        questionGroupRepositoryMock.deleteQuestionGroupHandler = { group in
            XCTAssertEqual(group, deleteGroup)
        }
        
        await store.send(.delete(deleteGroup)) {
            $0.groups = self.questionGroups
        }
        
        XCTAssertEqual(questionGroupRepositoryMock.deleteQuestionGroupCallCount, 1)
    }
    
    func testDeleteFailure() async {
        // NSError
        questionGroupRepositoryMock.deleteQuestionGroupHandler = { _ in
            throw NSError(domain: "Test Error", code: -9999)
        }
        
        await store.send(.delete(.init(name: "testDeleteFailure"))) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertNil(store.state.groups)
        
        // QuestionGroupUniqueError
        questionGroupRepositoryMock.deleteQuestionGroupHandler = { _ in
            throw QuestionGroupUniqueError()
        }
        
        await store.send(.delete(.init(name: "testDeleteFailure"))) {
            $0.errorAlert = .init {
                TextState("")
            } message: {
                TextState(L10n.Error.Question.Group.unique)
            }
        }
        XCTAssertNil(store.state.groups)
    }
    
    func testQuestionAdditionDismissed() async {
        let state = GroupAdditionReducer.State(questionAddition: .init(questionGroup: .init(name: "testQuestionAdditionDismissed")))
        store = makeStore(state: state)
        await store.send(.questionAdditionDismissed) {
            $0.questionAddition = nil
        }
    }
    
    func testDidTapNavBarButton() async {
        await store.send(.didTapNavBarButton) {
            $0.isShowingAddAlert = true
        }
    }
    
    func testDidTapEditSwipeAction() async {
        let updateGroup = QuestionGroup(name: "testDidTapEditSwipeAction")
        await store.send(.didTapEditSwipeAction(updateGroup)) {
            $0.groupToUpdate = updateGroup
            $0.updateGroupBody = updateGroup.name
            $0.isShowingUpdateAlert = true
        }
    }
    
    func testDidTapRow() async {
        let group = QuestionGroup(name: "testDidTapRow")
        let questionAdditionState = QuestionAdditionReducer.State(questionGroup: group)
        await store.send(.didTapRow(group)) {
            $0.questionAddition = questionAdditionState
        }
    }
    
    func testAlertDismissed() async {
        XCTAssertNil(store.state.errorAlert)
        await store.send(.alertDismissed)
    }
    
    private func makeStore(state: GroupAdditionReducer.State) -> Store {
        withDependencies {
            $0.questionGroupRepository = questionGroupRepositoryMock
        } operation: {
            TestStore(initialState: state,
                      reducer: GroupAdditionReducer())
        }
    }
}
