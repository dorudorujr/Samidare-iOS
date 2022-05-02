import SwiftUI

@MainActor
final class ConfigRouter {
    func makeGroupAdditionView() -> some View {
        GroupAdditionView(presenter: .init(interactor: .init(), router: .init()))
    }
}
