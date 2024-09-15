import SwiftUI

struct RootView: View {
    @StateObject private var router: AppRouter = .init()

    var body: some View {
        AppWrapper(root: .home)
            .environmentObject(router)
    }
}

struct AppWrapper: View {
    let root: AppRouter.Screen
    @EnvironmentObject var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            root.makeView()
                .navigationDestination(for: AppRouter.Screen.self) { screen in
                    switch screen {
                        default: screen.makeView().background(Color("AppBackgroundColor"))
                    }
                }
                .background(Color("AppBackgroundColor"))
        }
    }
}
