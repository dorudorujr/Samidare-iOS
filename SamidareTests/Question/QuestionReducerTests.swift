//
//  QuestionReducerTests.swift
//  SamidareTests
//
//  Created by 杉岡成哉 on 2023/03/11.
//

import XCTest
import ComposableArchitecture

@testable import Samidare

@MainActor
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
        questionRepositoryMock.lastQuestionHandler = { _ in
            self.lastQuestion
        }
        questionRepositoryMock.getIndexHandler = { _ in
            0
        }
        questionRepositoryMock.nextQuestionHandler = { _ in
            self.nextQuestion
        }
        store = makeStore(state: QuestionReducer.State())
    }
    
    func testPrimaryButtonTappedForStandBy() async {
        await store.send(.primaryButtonTapped) { state in
            state.status = .ready
            state.question = self.firstQuestion
            state.questionCountText = "1/3"
            state.nowTime = 3
            state.totalPlayTime = 10
        }
        await clock.advance(by: .seconds(0.1))
        // stateがreadyの時はplayingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 2.9
        }
    }
    
    func testPrimaryButtonTappedForReady() async {
        let state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .ready, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        await store.send(.primaryButtonTapped)
        await clock.advance(by: .seconds(0.1))
        // playingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 2.9
        }
    }
    
    func testPrimaryButtonTappedForPlay() async {
        let state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .play, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        questionRepositoryMock.getIndexHandler = { _ in
            1
        }
        
        await store.send(.primaryButtonTapped) { state in
            state.status = .play
            state.question = self.nextQuestion
            state.questionCountText = "2/3"
            state.nowTime = 10
        }
        await clock.advance(by: .seconds(0.1))
        // playingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 9.9
        }
    }
    
    func testPrimaryButtonTappedForStopReadying() async {
        let state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .stopReadying, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        await store.send(.primaryButtonTapped) { state in
            state.status = .ready
        }
        await clock.advance(by: .seconds(0.1))
        // playingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 2.9
        }
    }
    
    func testPrimaryButtonTappedForStopPlaying() async {
        let state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .stopPlaying, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        await store.send(.primaryButtonTapped) { state in
            state.status = .play
        }
        await clock.advance(by: .seconds(0.1))
        // playingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = 2.9
        }
    }
    
    func testPrimaryButtonTappedForDone() async {
        let state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .done, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        await store.send(.primaryButtonTapped) { state in
            state.shouldShowQuestionList = true
            state.status = .done
        }
    }
    
    func testPlayingForStandBy() async {
        let state = QuestionReducer.State(status: .standBy)
        store = makeStore(state: state)
        
        await store.send(.playing)
    }
    
    func testPlayingForStopPlaying() async {
        let state = QuestionReducer.State(status: .stopPlaying)
        store = makeStore(state: state)
        
        await store.send(.playing)
    }
    
    func testPlayingForStopReadying() async {
        let state = QuestionReducer.State(status: .stopReadying)
        store = makeStore(state: state)
        
        await store.send(.playing)
    }
    
    func testPlayingForDone() async {
        let state = QuestionReducer.State(status: .done)
        store = makeStore(state: state)
        
        await store.send(.playing)
    }
    
    func testPlayingForReady() async {
        questionRepositoryMock.getIndexHandler = { _ in
            2
        }
        var state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .ready, nowTime: 3, totalPlayTime: 10)
        store = makeStore(state: state)
        
        // カウントダウン中
        await store.send(.playing) { state in
            state.nowTime = 2.9
        }
        
        // ゲーム終了
        state = QuestionReducer.State(questionCountText: "1/3", question: nil, status: .ready, nowTime: 10, totalPlayTime: 10)
        store = makeStore(state: state)
        await store.send(.playing) { state in
            state.status = .done
            // カウントダウン時間に設定
            state.nowTime = 3
            // 最後に表示していた質問を表示
            state.question = self.lastQuestion
            state.questionCountText = "3/3"
        }
        
        // ゲーム開始
        state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .ready, nowTime: 0, totalPlayTime: 10)
        store = makeStore(state: state)
        await store.send(.playing) { state in
            state.status = .play
            // ゲーム時間に設定
            state.nowTime = 10
        }
    }
    
    func testPlayingForPlay() async {
        var state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .play, nowTime: 10, totalPlayTime: 10)
        store = makeStore(state: state)
        
        // ゲーム中
        await store.send(.playing) { state in
            state.nowTime = 9.9
        }
        
        // ゲーム終了
        questionRepositoryMock.getIndexHandler = { _ in
            2
        }
        state = QuestionReducer.State(questionCountText: "1/3", question: nil, status: .play, nowTime: 10, totalPlayTime: 10)
        store = makeStore(state: state)
        await store.send(.playing) { state in
            state.status = .done
            // カウントダウン時間に設定
            state.nowTime = 3
            // 最後に表示していた質問を表示
            state.question = self.lastQuestion
            state.questionCountText = "3/3"
        }
        
        // 次の質問へ
        questionRepositoryMock.getIndexHandler = { _ in
            1
        }
        state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .play, nowTime: 0, totalPlayTime: 10)
        store = makeStore(state: state)
        await store.send(.playing) { state in
            state.question = self.nextQuestion
            state.questionCountText = "2/3"
            // 回答時間を更新
            state.nowTime = 10
        }
    }
    
    func testSecondaryButtonTappedForStandBy() async {
        let state = QuestionReducer.State(status: .standBy)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped)
    }
    
    func testSecondaryButtonTappedForStopPlaying() async {
        let state = QuestionReducer.State(status: .stopPlaying)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped) { state in
            state.status = .standBy
        }
    }
    
    func testSecondaryButtonTappedForStopReadying() async {
        let state = QuestionReducer.State(status: .stopReadying)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped) { state in
            state.status = .standBy
        }
    }
    
    func testSecondaryButtonTappedForDone() async {
        let state = QuestionReducer.State(status: .done)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped) { state in
            state.status = .standBy
        }
    }
    
    func testSecondaryButtonTappedForReady() async {
        let state = QuestionReducer.State(status: .ready)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped) { state in
            state.status = .stopReadying
        }
    }
    
    func testSecondaryButtonTappedForPlay() async {
        let state = QuestionReducer.State(status: .play)
        store = makeStore(state: state)
        
        await store.send(.secondaryButtonTapped) { state in
            state.status = .stopPlaying
        }
    }
    
    func testSetSheet() async {
        let state = QuestionReducer.State(shouldShowQuestionList: false)
        store = makeStore(state: state)
        
        await store.send(.setSheet(isPresented: true)) { state in
            state.shouldShowQuestionList = true
        }
        await store.send(.setSheet(isPresented: false)) { state in
            state.shouldShowQuestionList = false
        }
    }
    
    // 途中で回答秒数を変更しても整合性が崩れないか確認
    func testNowTime() async {
        let totalPlayTime = 1
        // ゲーム開始になるときにnowTimeを更新する処理の確認
        var state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .ready, nowTime: 0.1, totalPlayTime: totalPlayTime)
        store = makeStore(state: state)
        
        await store.send(.primaryButtonTapped)
        
        await clock.advance(by: .seconds(0.2))
        await store.receive(.playing) {
            $0.nowTime = 0.0
        }
        // 回答時間を変更
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "QuestionReducerTest", time: 60)
        }
        // stateがreadyの時はplayingが呼ばれていることの確認
        await store.receive(.playing) {
            $0.nowTime = Double(totalPlayTime)
            $0.status = .play
        }
        
        // .runを終了させる
        await store.send(.secondaryButtonTapped) {
            $0.status = .stopPlaying
        }
        
        // 次の質問に行く時にnowTimeを更新する処理の確認
        state = QuestionReducer.State(questionCountText: "1/3", question: firstQuestion, status: .play, nowTime: 0.1, totalPlayTime: totalPlayTime)
        store = makeStore(state: state)

        await store.send(.playing) {
            $0.nowTime = 0.0
        }
        // 回答時間を変更
        appConfigRepositoryMock.getAppConfigHandler = {
            .init(questionGroupName: "QuestionReducerTest", time: 40)
        }
        // stateがreadyの時はplayingが呼ばれていることの確認
        await store.send(.playing) {
            $0.nowTime = Double(totalPlayTime)
            $0.question = self.nextQuestion
        }
    }
    
    private func makeStore(state: QuestionReducer.State) -> TestStore<QuestionReducer.State, QuestionReducer.Action, QuestionReducer.State, QuestionReducer.Action, ()> {
        withDependencies {
            $0.appConfigRepository = appConfigRepositoryMock
            $0.questionRepository = questionRepositoryMock
            $0.continuousClock = clock
        } operation: {
            TestStore(initialState: state,
                      reducer: QuestionReducer())
        }
    }
}
