import SwiftUI

@main
struct ZSBSupportAdminApp: App {

    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {

            if appState.isAdminLoggedIn {
                ChatListView()
            } else {
                AdminLoginView()
            }
        }
        .environmentObject(appState)
    }
}
