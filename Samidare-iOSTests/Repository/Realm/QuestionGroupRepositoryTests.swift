//
//  QuestionGroupRepositoryTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/05/16.
//

import XCTest
import RealmSwift
@testable import Samidare_iOS

class QuestionGroupRepositoryTests: XCTestCase {
    private let questionGroupRepository = QuestionGroupRepositoryImpl()
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testGetAndAdd() {
        XCTAssertTrue(questionGroupRepository.get().isEmpty)
        let group = QuestionGroup(name: "テスト")
        try! questionGroupRepository.add(group)
        let groups = questionGroupRepository.get()
        XCTAssertFalse(groups.isEmpty)
        XCTAssertEqual(groups.first!.id, group.id)
        XCTAssertEqual(groups.first!.name, group.name)
        
        // 同じグループ名のグループは登録できない
        let sameNameGroup = QuestionGroup(name: "テスト")
        try! questionGroupRepository.add(sameNameGroup)
        let sameNameGroups = questionGroupRepository.get()
        XCTAssertEqual(sameNameGroups.count, 1)
        XCTAssertEqual(sameNameGroups.first!.id, group.id)
        XCTAssertEqual(sameNameGroups.first!.name, group.name)
    }
    
    func testDelete() {
        // グループの追加
        let group = QuestionGroup(name: "テスト")
        try! questionGroupRepository.add(group)
        var groups = questionGroupRepository.get()
        XCTAssertFalse(groups.isEmpty)
        XCTAssertEqual(groups.first!.id, group.id)
        XCTAssertEqual(groups.first!.name, group.name)
        // グループの削除
        try! questionGroupRepository.delete(group)
        groups = questionGroupRepository.get()
        XCTAssertTrue(groups.isEmpty)
        
        /* グループに紐づいている質問の削除確認*/
        // 質問グループ追加
        let deleteGroup = QuestionGroup(name: "テスト")
        try! questionGroupRepository.add(deleteGroup)
        // 質問グループ取得
        groups = questionGroupRepository.get()
        XCTAssertEqual(groups.first!.id, deleteGroup.id)
        XCTAssertEqual(groups.first!.name, deleteGroup.name)
        // 質問追加
        let question = Question(body: "テスト中だよ", group: .init(name: "テスト"))
        try! QuestionRepositoryImpl.add(question)
        // 質問取得
        var questions = QuestionRepositoryImpl.getQuestions(of: "テスト")
        XCTAssertEqual(questions.first!.id, question.id)
        XCTAssertEqual(questions.first!.body, question.body)
        XCTAssertEqual(questions.first!.group.name, question.group.name)
        // 質問グループ削除
        try! questionGroupRepository.delete(deleteGroup)
        groups = questionGroupRepository.get()
        XCTAssertTrue(groups.isEmpty)
        questions = QuestionRepositoryImpl.getQuestions(of: "テスト")
        XCTAssertTrue(questions.isEmpty)
    }
}
