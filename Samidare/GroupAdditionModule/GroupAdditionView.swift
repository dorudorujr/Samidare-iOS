//
//  GroupAdditionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import SwiftUI
import ComposableArchitecture

struct GroupAdditionView: View {
    let store: StoreOf<GroupAdditionReducer>
    
    // swiftlint:disable closure_body_length
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                TextFieldAlertView(text: viewStore.binding(\.$addGroupBody),
                                   isShowingAlert: viewStore.binding(\.$isShowingAddAlert),
                                   placeholder: "",
                                   isSecureTextEntry: false,
                                   title: L10n.Group.Addition.Alert.title,
                                   message: L10n.Group.Addition.Alert.message,
                                   leftButtonTitle: L10n.Common.cancel,
                                   rightButtonTitle: L10n.Common.ok,
                                   leftButtonAction: nil,
                                   rightButtonAction: { viewStore.send(.addQuestionGroup) })
                TextFieldAlertView(text: viewStore.binding(\.$updateGroupBody),
                                   isShowingAlert: viewStore.binding(\.$isShowingUpdateAlert),
                                   placeholder: "",
                                   isSecureTextEntry: false,
                                   title: L10n.Group.Addition.Update.Alert.title,
                                   message: L10n.Group.Addition.Update.Alert.message,
                                   leftButtonTitle: L10n.Common.cancel,
                                   rightButtonTitle: L10n.Common.ok,
                                   leftButtonAction: nil,
                                   rightButtonAction: { viewStore.send(.update) })
                List {
                    Section {
                        if let groups = viewStore.groups {
                            ForEach(groups) { group in
                                // TODO: TCAのブランチにbeta版があるのでmainにマージされたら対応する
                                NavigationLink(
                                    destination: IfLetStore(self.store.scope(state: \.questionAddition, action: GroupAdditionReducer.Action.questionAddition)) {
                                    QuestionAdditionView(store: $0)
                                    },
                                    isActive: viewStore.binding(
                                        get: \.isQuestionAdditionActive,
                                        send: { $0 ? .didTapRow(group) : .questionAdditionDismissed }
                                    )
                                ) {
                                    Text(group.name)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.textBlack)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        viewStore.send(.didTapEditSwipeAction(group))
                                    } label: {
                                        Text(L10n.Common.edit)
                                    }
                                    .tint(.yellow)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewStore.send(.delete(group))
                                    } label: {
                                        Text(L10n.Common.delete)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle(L10n.Group.Addition.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.didTapNavBarButton) }, label: {
                            Image(systemName: "plus")
                                .renderingMode(.template)
                                .foregroundColor(.blue)
                        })
                    }
                }
                .alert(self.store.scope(state: \.errorAlert),
                       dismiss: .alertDismissed
                )
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct GroupAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        GroupAdditionView(store: .init(initialState: GroupAdditionReducer.State(),
                                       reducer: GroupAdditionReducer()))
    }
}
