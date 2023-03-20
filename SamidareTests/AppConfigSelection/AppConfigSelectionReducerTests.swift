//
//  AppConfigSelectionReducerTests.swift
//  SamidareTests
//
//  Created by 杉岡成哉 on 2023/03/20.
//

import XCTest
import ComposableArchitecture

@testable import Samidare

@MainActor
final class AppConfigSelectionReducerTests: XCTestCase {
    private var store: TestStore<AppConfigSelectionReducer.State, AppConfigSelectionReducer.Action, AppConfigSelectionReducer.State, AppConfigSelectionReducer.Action, ()>!
    private let appConfigRepositoryMock = AppConfigRepositoryProtocolMock()
    private let questionGroupRepositoryMock = QuestionGroupRepositoryProtocolMock()
    
    private let questionGroups: [QuestionGroup] = [
        .init(name: "testQuestionGroupOnAppear")
    ]
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "AppConfigSelectionReducerTests", time: 10)
        }
        questionGroupRepositoryMock.getQuestionGroupHandler = {
            self.questionGroups
        }
    }
    
    func testQuestionGroupOnAppear() async {
        store = makeStore(state: .init(type: .questionGroup))
        
        await store.send(.onAppear) {
            $0.questionGroups = self.questionGroups
            $0.selectQuestionGroupName = "AppConfigSelectionReducerTests"
        }
    }
    
    func testGameTimeOnAppear() async {
        store = makeStore(state: .init(type: .gameTime))
        
        await store.send(.onAppear) {
            $0.appConfigGameTime = 10
        }
    }
    
    func testUpdateQuestionGroupSuccess() async {
        store = makeStore(state: .init(type: .questionGroup))
        let updateQuestionGroup = QuestionGroup(name: "testUpdateQuestionGroup")
        
        appConfigRepositoryMock.updateAppConfigHandler = { appConfig in
            XCTAssertEqual(appConfig.questionGroupName, updateQuestionGroup.name)
            XCTAssertEqual(appConfig.time, 10)
        }
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: updateQuestionGroup.name, time: 10)
        }
        
        await store.send(.updateQuestionGroup(questionGroup: updateQuestionGroup)) {
            $0.questionGroups = self.questionGroups
            $0.selectQuestionGroupName = updateQuestionGroup.name
        }
        XCTAssertEqual(appConfigRepositoryMock.updateAppConfigCallCount, 1)
    }
    
    func testUpdateQuestionGroupFailure() async {
        store = makeStore(state: .init(type: .questionGroup))
        let updateQuestionGroup = QuestionGroup(name: "testUpdateQuestionGroup")
        
        appConfigRepositoryMock.updateAppConfigHandler = { appConfig in
            throw QuestionGroupUniqueError()
        }
        
        await store.send(.updateQuestionGroup(questionGroup: updateQuestionGroup)) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertEqual(appConfigRepositoryMock.updateAppConfigCallCount, 1)
    }
    
    func testUpdateGameTimeSuccess() async {
        store = makeStore(state: .init(type: .gameTime))
        
        appConfigRepositoryMock.updateAppConfigHandler = { appConfig in
            XCTAssertEqual(appConfig.questionGroupName, "AppConfigSelectionReducerTests")
            XCTAssertEqual(appConfig.time, 20)
        }
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "AppConfigSelectionReducerTests", time: 20)
        }
        
        await store.send(.updateGameTime(gameTime: 20)) {
            $0.appConfigGameTime = 20
        }
        XCTAssertEqual(appConfigRepositoryMock.updateAppConfigCallCount, 1)
    }
    
    func testUpdateGameTimeFailure() async {
        store = makeStore(state: .init(type: .gameTime))
        
        appConfigRepositoryMock.updateAppConfigHandler = { appConfig in
            throw QuestionGroupUniqueError()
        }
        
        await store.send(.updateGameTime(gameTime: 20)) {
            $0.errorAlert = .init {
                TextState(L10n.Error.title)
            } message: {
                TextState(L10n.Error.message)
            }
        }
        XCTAssertEqual(appConfigRepositoryMock.updateAppConfigCallCount, 1)
    }
    
    func testAlertDismissed() async {
        store = makeStore(state: .init(type: .questionGroup, errorAlert: .init(title: TextState("Test"))))
        
        await store.send(.alertDismissed) {
            $0.errorAlert = nil
        }
    }
    
    private func makeStore(state: AppConfigSelectionReducer.State) -> TestStore<AppConfigSelectionReducer.State, AppConfigSelectionReducer.Action, AppConfigSelectionReducer.State, AppConfigSelectionReducer.Action, ()> {
        withDependencies {
            $0.appConfigRepository = appConfigRepositoryMock
            $0.questionGroupRepository = questionGroupRepositoryMock
        } operation: {
            TestStore(initialState: state,
                      reducer: AppConfigSelectionReducer())
        }
    }
}
