import SwiftUI

@MainActor
final class ConfigRouter<AppConfigRepository: AppConfigRepositoryProtocol, QuestionGroupRepository: QuestionGroupRepositoryProtocol> {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView<QuestionGroupRepositoryImpl>(presenter: .init(interactor: .init(), router: .init()))
    }
    
    func makeAppConfigSelectionView(for type: AppConfigSelectionType,
                                    onDisappeare: @escaping () -> Void) -> some View {
        AppConfigSelectionView<AppConfigRepository, QuestionGroupRepository>(presenter: .init(interactor: .init(), type: type), description: type.description).onDisappear(perform: onDisappeare)
    }
}
