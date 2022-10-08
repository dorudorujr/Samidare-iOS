import SwiftUI

@MainActor
final class GroupAdditionRouter {
    func makeQuestionAdditionView(group: QuestionGroup) -> some View {
        QuestionAdditionView<QuestionRepositoryImpl>(presenter: .init(interactor: .init(), group: group))
    }
}
