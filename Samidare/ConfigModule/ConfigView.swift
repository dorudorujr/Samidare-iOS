//
//  ConfigView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import SwiftUI
import ComposableArchitecture

struct ConfigView: View {
    let store: StoreOf<ConfigReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    List {
                        Section {
                            // TODO: TCAのブランチにbeta版があるのでmainにマージされたら対応する
                            NavigationLink(
                                destination: IfLetStore(self.store.scope(state: \.groupAddition, action: ConfigReducer.Action.groupAddition)) {
                                    GroupAdditionView(store: $0)
                                },
                                isActive: viewStore.binding(
                                    get: \.isGroupAdditionActive,
                                    send: { $0 ? .didTapGroupAddition : .groupAdditionDismissed }
                                )
                            ) {
                                ListRow(title: L10n.Config.Add.question)
                            }
                            NavigationLink(
                                destination: IfLetStore(self.store.scope(state: \.questionGroupSelection, action: ConfigReducer.Action.questionGroupSelection)) {
                                    AppConfigSelectionView(store: $0, description: L10n.App.Config.Selection.Question.Group.description).onDisappear {
                                        viewStore.send(.appConfigSelectionDisappear)
                                    }
                                },
                                isActive: viewStore.binding(
                                    get: \.isQuestionGroupSelectionActive,
                                    send: { $0 ? .didTapQuestionGroupSelection : .questionGroupSelectionDismissed }
                                )
                            ) {
                                ListRow(title: L10n.Config.Display.group, description: viewStore.state.questionGroupName)
                            }
                            NavigationLink(
                                destination: IfLetStore(self.store.scope(state: \.gameTimeSelection, action: ConfigReducer.Action.gameTimeSelection)) {
                                    AppConfigSelectionView(store: $0, description: L10n.App.Config.Selection.Game.Time.description).onDisappear {
                                        viewStore.send(.appConfigSelectionDisappear)
                                    }
                                },
                                isActive: viewStore.binding(
                                    get: \.isGameTimeSelectionActive,
                                    send: { $0 ? .didTapGameTimeSelection : .gameTimeSelectionDismissed }
                                )
                            ) {
                                ListRow(title: L10n.Config.Answer.seconds, description: viewStore.state.playTime)
                            }
                        }
                        Section {
                            ListRow(title: L10n.Config.Use.app)
                            ListRow(title: L10n.Config.inquiry, shouldShowArrow: true)
                                .onTapGesture {
                                    viewStore.send(.didTapInquiry)
                                }
                        }
                        Section {
                            ListRow(title: L10n.Config.privacyPolicy, shouldShowArrow: true)
                                .onTapGesture {
                                    viewStore.send(.didTapSafariViewRow(externalLinkType: .privacyPolicy))
                                }
                            ListRow(title: L10n.Config.Terms.Of.service, shouldShowArrow: true)
                                .onTapGesture {
                                    viewStore.send(.didTapSafariViewRow(externalLinkType: .termsOfservice))
                                }
                            ListRow(title: L10n.Config.version, description: viewStore.state.appVersion)
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
                FirebaseAnalyticsConfig.sendScreenViewLog(screenName: "\(ConfigView.self)")
                viewStore.send(.onAppear)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.shouldShowSheet,
                send: ConfigReducer.Action.setSheet(shouldShowSheet:)
            )) {
                if viewStore.state.sheetType == .safariView {
                    if let string = viewStore.state.selectedExternalLinkType?.url,
                       let url = URL(string: string) {
                        SafariView(url: url)
                    }
                } else if viewStore.sheetType == .mailer {
                    MailView(isShowing: viewStore.binding(
                        get: \.shouldShowSheet,
                        send: ConfigReducer.Action.setSheet(shouldShowSheet:)
                    ))
                }
            }
            .alert(self.store.scope(state: \.errorAlert),
                   dismiss: .alertDismissed
            )
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(store: .init(initialState: ConfigReducer.State(),
                                reducer: ConfigReducer()))
    }
}
