//
//  ConfigPresenterTests.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import XCTest
import SwiftUI
@testable import Samidare_iOS

class ConfigPresenterTests: XCTestCase {
    private var presenter: ConfigPresenter<AppConfigRepositoryProtocolMock>!
    
    override func setUp() {
        super.setUp()
        AppConfigRepositoryProtocolMock.getHandler = {
            .init(questionGroup: .init(name: "questionGroup"),
                  time: 1)
        }
    }
    
    func testGetAppConfig() async {
        presenter = await .init(interactor: .init(), router: .init())
        var questionGroup = await presenter.questionGroup
        XCTAssertNil(questionGroup)
        var playTime = await presenter.playTime
        XCTAssertNil(playTime)
        await presenter.getAppConfig()
        questionGroup = await presenter.questionGroup
        XCTAssertEqual(questionGroup, "questionGroup")
        playTime = await presenter.playTime
        XCTAssertEqual(playTime, "1")
    }
    
    func testGroupAdditionLinkBuilder() async {
        let router: ConfigRouter = await .init()
        presenter = await .init(interactor: .init(), router: router)
        let someView = await presenter.groupAdditionLinkBuilder {} as? NavigationLink<EmptyView, GroupAdditionView<QuestionGroupRepositoryImpl>>
        XCTAssertNotNil(someView)
    }
    
    func testAppConfigSelectionLinkBuilder() async {
        let router: ConfigRouter = await .init()
        presenter = await .init(interactor: .init(), router: router)
        let someView = await presenter.appConfigSelectionLinkBuilder(for: .questionGroup) {} as? NavigationLink<EmptyView, ModifiedContent<AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>, _AppearanceActionModifier>>
        XCTAssertNotNil(someView)
    }
    
    func testDidTapSafariViewList() async {
        let router: ConfigRouter = await .init()
        presenter = await .init(interactor: .init(), router: router)
        var selectedExternalLinkType = await presenter.selectedExternalLinkType
        var shouldShowSafariView = await presenter.shouldShowSafariView
        XCTAssertNil(selectedExternalLinkType)
        XCTAssertFalse(shouldShowSafariView)
        
        await presenter.didTapSafariViewList(of: .privacyPolicy)
        selectedExternalLinkType = await presenter.selectedExternalLinkType
        shouldShowSafariView = await presenter.shouldShowSafariView
        XCTAssertEqual(selectedExternalLinkType, .privacyPolicy)
        XCTAssertTrue(shouldShowSafariView)
        XCTAssertEqual(selectedExternalLinkType!.url, "https://samidare-develop.firebaseapp.com/PrivacyPolicy.html")
        
        await presenter.didTapSafariViewList(of: .termsOfservice)
        selectedExternalLinkType = await presenter.selectedExternalLinkType
        shouldShowSafariView = await presenter.shouldShowSafariView
        XCTAssertEqual(selectedExternalLinkType, .termsOfservice)
        XCTAssertTrue(shouldShowSafariView)
        XCTAssertEqual(selectedExternalLinkType!.url, "https://samidare-develop.firebaseapp.com/TermsOfService.html")
    }
}
