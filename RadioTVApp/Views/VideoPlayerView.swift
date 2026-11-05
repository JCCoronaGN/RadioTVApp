import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var viewModel: VideoPlayerViewModel

    init(channel: TVChannel) {
        _viewModel = State(initialValue: VideoPlayerViewModel(channel: channel))
    }

    var body: some View {
        VStack {
            Text(viewModel.channel.name)
                .font(.headline)
                .padding(.top)

            if viewModel.failed {
                UnavailableView(
                    title: "Contenido no disponible",
                    message: "Este canal no se puede reproducir en este momento.",
                    systemImage: "tv.slash"
                )
            } else if let player = viewModel.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: .bottom)
            } else {
                ProgressView("Cargando canal...")
            }
        }
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
