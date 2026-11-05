import SwiftUI

struct MainTabView: View {
    let session: SessionManager

    var body: some View {
        TabView {
            RadioListView()
                .tabItem {
                    Label("Radio", systemImage: "dot.radiowaves.left.and.right")
                }

            TVListView()
                .tabItem {
                    Label("TV", systemImage: "tv")
                }

            SessionView(session: session)
                .tabItem {
                    Label("Sesión", systemImage: "person.crop.circle")
                }
        }
    }
}

struct SessionView: View {
    let session: SessionManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Sesión activa")
                    .font(.title3)
                Button("Cerrar sesión", role: .destructive) {
                    session.logout()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Cuenta")
        }
    }
}
