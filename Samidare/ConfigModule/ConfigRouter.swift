import SwiftUI

@MainActor
final class ConfigRouter<AppConfigRepository: AppConfigRepositoryProtocol, QuestionGroupRepository: QuestionGroupRepositoryProtocol> {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView(store: .init(initialState: GroupAdditionReducer.State(),
                                       reducer: GroupAdditionReducer()))
    }
    
    func makeAppConfigSelectionView(for type: AppConfigSelectionType,
                                    onDisappeare: @escaping () -> Void) -> some View {
        AppConfigSelectionView(store: .init(initialState: AppConfigSelectionReducer.State(type: type),
                                            reducer: AppConfigSelectionReducer()),
                               description: type.description).onDisappear(perform: onDisappeare)
    }
}
