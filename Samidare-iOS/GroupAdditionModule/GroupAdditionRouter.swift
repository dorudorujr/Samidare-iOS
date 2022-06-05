import SwiftUI

@MainActor
final class GroupAdditionRouter {
    func makeQuestionAdditionView(group: String) -> some View {
        QuestionAdditionView<QuestionRepositoryImpl>(presenter: .init(interactor: .init(), group: group))
    }
}
