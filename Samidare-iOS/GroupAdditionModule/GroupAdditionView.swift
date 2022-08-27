//
//  GroupAdditionView.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import SwiftUI

struct GroupAdditionView<Repository: QuestionGroupRepositoryProtocol>: View {
    @ObservedObject private var presenter: GroupAdditionPresenter<Repository>
    
    init(presenter: GroupAdditionPresenter<Repository>) {
        self.presenter = presenter
    }
    
    // swiftlint:disable closure_body_length
    var body: some View {
        ZStack {
            TextFieldAlertView(text: $presenter.addAlertText,
                               isShowingAlert: $presenter.isShowingAddAlert,
                               placeholder: "",
                               isSecureTextEntry: false,
                               title: L10n.Group.Addition.Alert.title,
                               message: L10n.Group.Addition.Alert.message,
                               leftButtonTitle: L10n.Common.cancel,
                               rightButtonTitle: L10n.Common.ok,
                               leftButtonAction: nil,
                               rightButtonAction: { presenter.addQuestionGroup() })
            TextFieldAlertView(text: $presenter.editAlertText,
                               isShowingAlert: $presenter.isShowingEditAlert,
                               placeholder: "",
                               isSecureTextEntry: false,
                               title: L10n.Group.Addition.Update.Alert.title,
                               message: L10n.Group.Addition.Update.Alert.message,
                               leftButtonTitle: L10n.Common.cancel,
                               rightButtonTitle: L10n.Common.ok,
                               leftButtonAction: nil,
                               rightButtonAction: { presenter.editQuestionGroupName() })
            List {
                Section {
                    if let groups = self.presenter.groups {
                        ForEach(groups) { group in
                            presenter.questionAdditionLinkBuilder(group: group) {
                                Text(group.name)
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.textBlack)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    presenter.didTapEditSwipeAction(editQuestionGroup: group)
                                } label: {
                                    Text(L10n.Common.edit)
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    presenter.delete(group)
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
                    Button(action: { presenter.didTapNavBarButton() }, label: {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                    })
                }
            }
            .alert(isPresented: $presenter.isShowingQuestionGroupUniqueErrorAlert) {
                Alert(title: Text(""), message: Text(L10n.Error.Question.Group.unique))
            }
        }
    }
}

struct GroupAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        GroupAdditionView<QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
}
