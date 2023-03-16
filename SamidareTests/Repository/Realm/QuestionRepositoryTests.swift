//
//  QuestionRepositoryTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
import RealmSwift
@testable import Samidare

class QuestionRepositoryTests: XCTestCase {
    let questionRepositoryImpl = QuestionRepositoryImpl()
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        super.tearDown()
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testAddAndGetQuestions() {
        // 存在しないグループ
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        // 存在しないグループに質問追加
        XCTAssertThrowsError(try QuestionRepositoryImpl.add(.init(body: "テスト中だよ", group: .init(name: "デフォルト"))))

        // 存在するグループに質問追加
        let group = QuestionGroup(name: "デフォルト")
        try! QuestionGroupRepositoryImpl.add(group)
        try! QuestionRepositoryImpl.add(.init(body: "テスト中だよ", group: group))
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.last!.body, "テスト中だよ")
        XCTAssertEqual(defaultQuestions.last!.group.name, "デフォルト")
    }
    
    func testGetIndex() {
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        let group = QuestionGroup(name: "デフォルト")
        try! QuestionGroupRepositoryImpl.add(group)
        let firstQuestion = Question(body: "最初の質問", group: group)
        let nextQuestion = Question(body: "2番目の質問", group: group)
        try! questionRepositoryImpl.add(firstQuestion)
        try! questionRepositoryImpl.add(nextQuestion)
        
        XCTAssertEqual(questionRepositoryImpl.getIndex(of: firstQuestion)!, 0)
        XCTAssertEqual(questionRepositoryImpl.getIndex(of: nextQuestion)!, 1)
    }
    
    func testNextQuestion() {
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        let group = QuestionGroup(name: "デフォルト")
        try! QuestionGroupRepositoryImpl.add(group)
        let firstQuestion = Question(body: "最初の質問", group: group)
        let nextQuestion = Question(body: "2番目の質問", group: group)
        let lastQuestion = Question(body: "最後の質問", group: group)
        let otherQuestion = Question(body: "登録されていない質問", group: group)
        try! questionRepositoryImpl.add(firstQuestion)
        try! questionRepositoryImpl.add(nextQuestion)
        try! questionRepositoryImpl.add(lastQuestion)
        
        XCTAssertEqual(questionRepositoryImpl.nextQuestion(for: firstQuestion), nextQuestion)
        XCTAssertEqual(questionRepositoryImpl.nextQuestion(for: nextQuestion), lastQuestion)
        XCTAssertEqual(questionRepositoryImpl.nextQuestion(for: otherQuestion), firstQuestion)
    }
    
    func testFirstQuestion() {
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        let group = QuestionGroup(name: "デフォルト")
        try! QuestionGroupRepositoryImpl.add(group)
        let firstQuestion = Question(body: "最初の質問", group: group)
        let nextQuestion = Question(body: "2番目の質問", group: group)
        let lastQuestion = Question(body: "最後の質問", group: group)
        
        try! questionRepositoryImpl.add(firstQuestion)
        try! questionRepositoryImpl.add(nextQuestion)
        try! questionRepositoryImpl.add(lastQuestion)
        
        XCTAssertEqual(questionRepositoryImpl.firstQuestion(of: group.name), questionRepositoryImpl.getQuestions(of: group.name).first)
    }
    
    func testLastQuestion() {
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        let group = QuestionGroup(name: "デフォルト")
        try! QuestionGroupRepositoryImpl.add(group)
        let firstQuestion = Question(body: "最初の質問", group: group)
        let nextQuestion = Question(body: "2番目の質問", group: group)
        let lastQuestion = Question(body: "最後の質問", group: group)
        
        try! questionRepositoryImpl.add(firstQuestion)
        try! questionRepositoryImpl.add(nextQuestion)
        try! questionRepositoryImpl.add(lastQuestion)
        
        XCTAssertEqual(questionRepositoryImpl.lastQuestion(of: group.name), questionRepositoryImpl.getQuestions(of: group.name).last)
    }
    
    func testUpdate() {
        let group = QuestionGroup(name: "デフォルト")
        let question = Question(body: "更新テスト中だよ", group: group)
        // 質問グループ追加
        try! QuestionGroupRepositoryImpl.add(group)
        // 質問追加
        try! QuestionRepositoryImpl.add(question)
        let defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.first!.body, "更新テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        
        // 質問更新
        let updateQuestion = Question(id: question.id, body: "質問更新中だよ", group: question.group)
        try! QuestionRepositoryImpl.update(updateQuestion)
        let updateQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(updateQuestions.count, 1)
        XCTAssertEqual(updateQuestions.first!.id, question.id)
        XCTAssertEqual(updateQuestions.first!.body, updateQuestion.body)
        XCTAssertEqual(updateQuestions.first!.group.name, question.group.name)
        
        // 存在しない質問の場合はErrorを返す
        let nonExistentQuestion = Question(body: "DBにはない質問だよ", group: .init(name: "デフォルト"))
        var questions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        // nonexistentQuestionがDBに存在しないことを確認
        XCTAssertEqual(questions.count, 1)
        XCTAssertNotEqual(questions.first!.id, nonExistentQuestion.id)
        
        XCTAssertThrowsError(try QuestionRepositoryImpl.update(nonExistentQuestion))
        questions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(questions.count, 1)
        XCTAssertEqual(questions.first!.id, updateQuestion.id)
        
        // 存在しないグループの質問の場合はErrorを返す
        let nonExistentGroupQuestion = Question(body: "DBには存在しないグループの質問だよ", group: .init(name: "カスタム"))
        
        XCTAssertThrowsError(try QuestionRepositoryImpl.update(nonExistentGroupQuestion))
        questions = QuestionRepositoryImpl.getQuestions(of: "カスタム")
        XCTAssertTrue(questions.isEmpty)
    }
    
    func testDelete() {
        let group = QuestionGroup(name: "デフォルト")
        let question = Question(body: "削除テスト中だよ", group: group)
        // 質問グループ追加
        try! QuestionGroupRepositoryImpl.add(group)
        // 質問追加
        try! QuestionRepositoryImpl.add(question)
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.first!.body, "削除テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        
        // DBにないグループの質問を削除
        let nonExistGroupQuestion = Question(body: "存在しないグループの質問だよ", group: .init(name: "カスタム"))
        XCTAssertThrowsError(try QuestionRepositoryImpl.delete(nonExistGroupQuestion))
        
        // DBにない質問を削除
        // 特に何も起きない
        let nonExistQuestion = Question(body: "存在しない質問だよ", group: group)
        try! QuestionRepositoryImpl.delete(nonExistQuestion)
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.first!.body, "削除テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        
        //　DBにある質問を削除
        // 正常に削除される
        try! QuestionRepositoryImpl.delete(question)
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
    }
}
