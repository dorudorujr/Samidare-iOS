//
//  QuestionRepositoryTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/14.
//

import XCTest
import RealmSwift
@testable import Samidare_iOS

class QuestionRepositoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testAddAndGetQuestions() {
        // 存在しないグループ
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
        // 存在しないグループに質問追加
        try! QuestionRepositoryImpl.add(.init(body: "テスト中だよ", group: .init(name: "デフォルト")))
        // 存在するグループから質問を取得
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.last!.body, "テスト中だよ")
        XCTAssertEqual(defaultQuestions.last!.group.name, "デフォルト")
        
        // 存在するグループに質問追加
        try! QuestionRepositoryImpl.add(.init(body: "テスト中だよパート2", group: .init(name: "デフォルト")))
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 2)
        XCTAssertEqual(defaultQuestions.first!.body, "テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        XCTAssertEqual(defaultQuestions.last!.body, "テスト中だよパート2")
        XCTAssertEqual(defaultQuestions.last!.group.name, "デフォルト")
    }
    
    func testUpdate() {
        let question = Question(body: "更新テスト中だよ", group: .init(name: "デフォルト"))
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
        
        // 実装として、存在しない質問の場合は追加する
        let nonExistentQuestion = Question(body: "DBにはない質問だよ", group: .init(name: "デフォルト"))
        var questions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        // nonexistentQuestionがDBに存在しないことを確認
        XCTAssertEqual(questions.count, 1)
        XCTAssertNotEqual(questions.first!.id, nonExistentQuestion.id)
        
        try! QuestionRepositoryImpl.update(nonExistentQuestion)
        questions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(questions.count, 2)
        XCTAssertEqual(questions.last!.id, nonExistentQuestion.id)
        
        // 存在しないグループの質問の場合は何もしない
        let nonExistentGroupQuestion = Question(body: "DBには存在しないグループの質問だよ", group: .init(name: "カスタム"))
        
        try! QuestionRepositoryImpl.update(nonExistentGroupQuestion)
        questions = QuestionRepositoryImpl.getQuestions(of: "カスタム")
        XCTAssertTrue(questions.isEmpty)
    }
    
    func testDelete() {
        let question = Question(body: "更新テスト中だよ", group: .init(name: "デフォルト"))
        // 質問追加
        try! QuestionRepositoryImpl.add(question)
        var defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.first!.body, "更新テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        
        // DBにない質問を削除
        // 特に何も起きない
        let nonExistQuestion = Question(body: "存在しない質問だよ", group: .init(name: "デフォルト"))
        try! QuestionRepositoryImpl.delete(nonExistQuestion)
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertEqual(defaultQuestions.count, 1)
        XCTAssertEqual(defaultQuestions.first!.body, "更新テスト中だよ")
        XCTAssertEqual(defaultQuestions.first!.group.name, "デフォルト")
        
        //　DBにある質問を削除
        // 正常に削除される
        try! QuestionRepositoryImpl.delete(question)
        defaultQuestions = QuestionRepositoryImpl.getQuestions(of: "デフォルト")
        XCTAssertTrue(defaultQuestions.isEmpty)
    }
}
