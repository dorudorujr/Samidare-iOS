import SwiftUI

@MainActor
final class ConfigRouter {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView<QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
    
    func makeAppConfigSelectionView() -> some View {
        AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init()), description: L10n.App.Config.Selection.Question.Group.description)
    }
}
