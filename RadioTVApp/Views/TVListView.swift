import SwiftUI

struct TVListView: View {
    @State private var viewModel = TVListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Cargando canales...")
                case .empty(let message):
                    UnavailableView(
                        title: "Sin contenido",
                        message: message,
                        systemImage: "tv.slash"
                    )
                case .failed(let message):
                    UnavailableView(
                        title: "Error",
                        message: message,
                        systemImage: "exclamationmark.triangle"
                    )
                case .loaded(let channels):
                    List(channels) { channel in
                        NavigationLink(channel.name) {
                            VideoPlayerView(channel: channel)
                        }
                    }
                }
            }
            .navigationTitle("TV")
            .task {
                await viewModel.loadIfNeeded()
            }
        }
    }
}
