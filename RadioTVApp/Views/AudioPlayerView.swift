import SwiftUI

struct AudioPlayerView: View {
    @State private var viewModel: AudioPlayerViewModel

    init(station: RadioStation) {
        _viewModel = State(initialValue: AudioPlayerViewModel(station: station))
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "radio")
                .font(.system(size: 56))
                .foregroundStyle(.tint)

            Text(viewModel.station.name)
                .font(.title2).bold()
                .multilineTextAlignment(.center)

            Text("\(viewModel.station.genreText) · \(viewModel.station.countryText)")
                .foregroundStyle(.secondary)

            if !viewModel.hasStreamURL || viewModel.failed {
                UnavailableView(
                    title: "Contenido no disponible",
                    message: "Esta estación no se puede reproducir en este momento.",
                    systemImage: "speaker.slash"
                )
            } else {
                Text(viewModel.isPlaying ? "Reproduciendo" : "En pausa")
                    .foregroundStyle(.secondary)

                Button {
                    viewModel.togglePlayPause()
                } label: {
                    Label(
                        viewModel.isPlaying ? "Pausar" : "Reanudar",
                        systemImage: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill"
                    )
                    .font(.title)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .navigationTitle("Reproductor")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}
