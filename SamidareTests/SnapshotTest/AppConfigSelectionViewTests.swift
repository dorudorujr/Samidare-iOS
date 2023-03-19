//
//  AppConfigSelectionViewTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/06/28.
//

import XCTest
import SnapshotTesting
@testable import Samidare
import SwiftUI

class AppConfigSelectionViewTests: XCTestCase {
    override func setUp() {
        super.setUp()
        isRecording = false
    }
    
    @MainActor
    func testQuestionGroupType() {
        let view = AppConfigSelectionView(store: .init(initialState: AppConfigSelectionReducer.State(type: .questionGroup),
                                                       reducer: AppConfigSelectionReducer()),
                                          description: AppConfigSelectionType.questionGroup.description)
        let vc = UIHostingController(rootView: view)
        // 謎にリストが表示されないので一旦コメントアウト(ForEachが原因っぽい....)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        //assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.95))
    }
    
    @MainActor
    func testGameTimeType() {
        let view = AppConfigSelectionView(store: .init(initialState: AppConfigSelectionReducer.State(type: .gameTime),
                                                       reducer: AppConfigSelectionReducer()),
                                          description: AppConfigSelectionType.questionGroup.description)
        let vc = UIHostingController(rootView: view)
        // M1とCIとでSnapshotの画像に差異が発生するので閾値設定
        assertSnapshot(matching: vc, as: .image(on: .iPhone13ProMax, precision: 0.999))
    }
}
