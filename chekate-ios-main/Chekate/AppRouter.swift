import Combine
import Foundation
import SwiftUI

final class AppRouter: ObservableObject {
    @Published private(set) var firstTabRoot: AppRouter.Screen = .home

    enum Screen: Hashable {
        case home
        case diagnostic
        case loading
        case result(prompt: String, result: String)
    }

    @Published var isPresented: Bool
    @Published var path: [AppRouter.Screen] = []

    init() {
        _isPresented = Published(initialValue: false)
    }

    func back() {
        // Do not pop back to zero to avoid showing a white-screen.
        if path.count > 1 {
            _ = path.popLast()
        } else {
            exit()
        }
    }

    func append(toScreen screen: AppRouter.Screen) {
        path.append(screen)
    }

    func exit() {
        isPresented = false
        path.removeAll()
    }
}

extension AppRouter.Screen {
    @ViewBuilder func makeView() -> some View {
        switch self {
            case .home: HomeScreen()
            case .diagnostic: DiagnosticScreen().background(Color("AppBackgroundColor"))
            case .loading: EmptyView()
            case .result(let prompt, let result): ResultsScreen(prompt: prompt, result: result)
        }
    }
}
