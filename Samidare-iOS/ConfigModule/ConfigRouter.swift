import SwiftUI

@MainActor
final class ConfigRouter {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView<QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
    
    func makeAppConfigSelectionView(for type: AppConfigSelectionType) -> some View {
        AppConfigSelectionView<AppConfigRepositoryImpl, QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), type: type), description: type.description)
    }
}
