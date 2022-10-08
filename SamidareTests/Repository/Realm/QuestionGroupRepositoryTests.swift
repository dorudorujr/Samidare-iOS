//
//  QuestionGroupRepositoryTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/16.
//

import XCTest
import RealmSwift
@testable import Samidare

class QuestionGroupRepositoryTests: XCTestCase {
    private let questionGroupRepository = QuestionGroupRepositoryImpl()
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testGetAndAdd() {
        XCTAssertTrue(QuestionGroupRepositoryImpl.get().isEmpty)
        let group = QuestionGroup(name: "テスト")
        try! QuestionGroupRepositoryImpl.add(group)
        let groups = QuestionGroupRepositoryImpl.get()
        XCTAssertFalse(groups.isEmpty)
        XCTAssertEqual(groups.first!.id, group.id)
        XCTAssertEqual(groups.first!.name, group.name)
        
        // 同じグループ名のグループは登録できない
        let sameNameGroup = QuestionGroup(name: "テスト")
        do {
            try QuestionGroupRepositoryImpl.add(sameNameGroup)
        } catch {
        }
        let sameNameGroups = QuestionGroupRepositoryImpl.get()
        XCTAssertEqual(sameNameGroups.count, 1)
        XCTAssertEqual(sameNameGroups.first!.id, group.id)
        XCTAssertEqual(sameNameGroups.first!.name, group.name)
    }
    
    func testDelete() {
        // グループの追加
        let group = QuestionGroup(name: "テスト")
        try! QuestionGroupRepositoryImpl.add(group)
        var groups = QuestionGroupRepositoryImpl.get()
        XCTAssertFalse(groups.isEmpty)
        XCTAssertEqual(groups.first!.id, group.id)
        XCTAssertEqual(groups.first!.name, group.name)
        // グループの削除
        try! QuestionGroupRepositoryImpl.delete(group)
        groups = QuestionGroupRepositoryImpl.get()
        XCTAssertTrue(groups.isEmpty)
        
        /* グループに紐づいている質問の削除確認*/
        // 質問グループ追加
        let deleteGroup = QuestionGroup(name: "テスト")
        try! QuestionGroupRepositoryImpl.add(deleteGroup)
        // 質問グループ取得
        groups = QuestionGroupRepositoryImpl.get()
        XCTAssertEqual(groups.first!.id, deleteGroup.id)
        XCTAssertEqual(groups.first!.name, deleteGroup.name)
        // 質問追加
        let question = Question(body: "テスト中だよ", group: deleteGroup)
        try! QuestionRepositoryImpl.add(question)
        // 質問取得
        var questions = QuestionRepositoryImpl.getQuestions(of: "テスト")
        XCTAssertEqual(questions.first!.id, question.id)
        XCTAssertEqual(questions.first!.body, question.body)
        XCTAssertEqual(questions.first!.group.name, question.group.name)
        // 質問グループ削除
        try! QuestionGroupRepositoryImpl.delete(deleteGroup)
        groups = QuestionGroupRepositoryImpl.get()
        XCTAssertTrue(groups.isEmpty)
        questions = QuestionRepositoryImpl.getQuestions(of: "テスト")
        XCTAssertTrue(questions.isEmpty)
    }
}
