import SwiftUI

@main
struct RadioTVAppApp: App {
    @State private var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                MainTabView(session: session)
            } else {
                LoginView(session: session)
            }
        }
    }
}
