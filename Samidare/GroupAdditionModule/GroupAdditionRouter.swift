import SwiftUI

@MainActor
final class GroupAdditionRouter {
    func makeQuestionAdditionView(group: QuestionGroup) -> some View {
        QuestionAdditionView(store: .init(initialState: QuestionAdditionReducer.State(questionGroup: group),
                                          reducer: QuestionAdditionReducer()))
    }
}
