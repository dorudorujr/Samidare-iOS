//
//  QuestionReducerTests.swift
//  SamidareTests
//
//  Created by 杉岡成哉 on 2023/03/11.
//

import XCTest
import ComposableArchitecture

@testable import Samidare

final class QuestionReducerTests: XCTestCase {
    private var store: TestStore<QuestionReducer.State, QuestionReducer.Action, QuestionReducer.State, QuestionReducer.Action, ()>!
    private let appConfigRepositoryMock = AppConfigRepositoryProtocolMock()
    private let questionRepositoryMock = QuestionRepositoryProtocolMock()
    private let clock = TestClock()
    private let questionGroup = QuestionGroup(name: "QuestionReducerTest")
    private lazy var firstQuestion = Question(body: "好きな色", group: questionGroup)
    private lazy var nextQuestion = Question(body: "好きな食べ物", group: questionGroup)
    private lazy var lastQuestion = Question(body: "好きな車", group: questionGroup)
    private lazy var questions: [Question] = [
        firstQuestion,
        nextQuestion,
        lastQuestion
    ]
    
    override func setUp() {
        super.setUp()
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "QuestionReducerTest", time: 10)
        }
        questionRepositoryMock.getQuestionsOfHandler = { _ in
            self.questions
        }
        questionRepositoryMock.firstQuestionHandler = { _ in
            self.firstQuestion
        }
        store = withDependencies {
            $0.appConfigRepository = appConfigRepositoryMock
            $0.questionRepository = questionRepositoryMock
            $0.continuousClock = clock
        } operation: {
            TestStore(initialState: QuestionReducer.State(),
                      reducer: QuestionReducer())
        }
    }
    
    func testPrimaryButtonTapped() async {
        // StatusがstandBy
        questionRepositoryMock.getIndexHandler = { _ in
            0
        }
        await store.send(.primaryButtonTapped) { state in
            state.status = .ready
            state.question = self.firstQuestion
            state.questionCountText = "1/3"
            state.nowTime = 3
            state.totalPlayTime = 10
        }
        await clock.advance(by: .seconds(0.1))
        // playingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 2.9
        }
    }
}
