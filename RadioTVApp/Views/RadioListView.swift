import SwiftUI

struct RadioListView: View {
    @State private var viewModel = RadioListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Cargando estaciones...")
                case .empty(let message):
                    UnavailableView(
                        title: "Sin contenido",
                        message: message,
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                case .failed(let message):
                    UnavailableView(
                        title: "Error",
                        message: message,
                        systemImage: "exclamationmark.triangle"
                    )
                case .loaded(let stations):
                    List(stations) { station in
                        NavigationLink {
                            AudioPlayerView(station: station)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(station.name)
                                    .font(.headline)
                                Text("\(station.genreText) · \(station.countryText)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Radio")
            .task {
                await viewModel.loadIfNeeded()
            }
        }
    }
}
