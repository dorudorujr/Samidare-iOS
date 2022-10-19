//
//  ConfigView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import SwiftUI

struct ConfigView<AppConfigRepository: AppConfigRepositoryProtocol, QuestionGroupRepository: QuestionGroupRepositoryProtocol>: View {
    @ObservedObject private var presenter: ConfigPresenter<AppConfigRepository, QuestionGroupRepository>
    
    init(presenter: ConfigPresenter<AppConfigRepository, QuestionGroupRepository>) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        presenter.groupAdditionLinkBuilder {
                            ListRow(title: L10n.Config.Add.question)
                        }
                        presenter.appConfigSelectionLinkBuilder(for: .questionGroup) {
                            ListRow(title: L10n.Config.Display.group, description: presenter.questionGroup)
                        }
                        presenter.appConfigSelectionLinkBuilder(for: .gameTime) {
                            ListRow(title: L10n.Config.Answer.seconds, description: presenter.playTime)
                        }
                    }
                    Section {
                        ListRow(title: L10n.Config.Use.app)
                        ListRow(title: L10n.Config.inquiry)
                            .onTapGesture {
                                presenter.didTapInquiry()
                            }
                    }
                    Section {
                        ListRow(title: L10n.Config.privacyPolicy, shouldShowArrow: true)
                            .onTapGesture {
                                presenter.didTapSafariViewList(of: .privacyPolicy)
                            }
                        ListRow(title: L10n.Config.Terms.Of.service, shouldShowArrow: true)
                            .onTapGesture {
                                presenter.didTapSafariViewList(of: .termsOfservice)
                            }
                        ListRow(title: L10n.Config.version, description: presenter.appVersion)
                    }
                }
                .listStyle(.insetGrouped)
                Spacer()
                AdmobBannerView().frame(width: 320, height: 50)
            }
            .navigationTitle(L10n.Config.NavigationBar.title)
            .background(Color.listBackground)
        }
        .onAppear {
            presenter.getAppConfig()
            FirebaseAnalyticsConfig.sendScreenViewLog(screenName: "\(ConfigView.self)")
        }
        .sheet(isPresented: $presenter.shouldShowSheet) {
            if presenter.sheetType == .safariView {
                if let string = presenter.selectedExternalLinkType?.url,
                   let url = URL(string: string) {
                    SafariView(url: url)
                }
            } else if presenter.sheetType == .mailer {
                MailView(isShowing: $presenter.shouldShowSheet)
            }
        }
        .alert(isPresented: $presenter.shouldShowAlert) {
            Alert(title: Text(L10n.Mail.Error.title), message: Text(L10n.Mail.Error.description))
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
}
