import SwiftUI

@MainActor
final class ConfigRouter {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView<QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
}
