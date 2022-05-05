import SwiftUI

@MainActor
final class GroupAdditionRouter {
    func makeQuestionAdditionView(group: String) -> some View {
        QuestionAdditionView(presenter: .init(interactor: .init(), group: group))
    }
}
