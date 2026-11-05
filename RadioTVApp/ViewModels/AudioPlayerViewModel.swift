import Foundation

@MainActor
@Observable
final class AudioPlayerViewModel {
    let station: RadioStation
    private let manager = AudioPlayerManager()

    var isPlaying: Bool { manager.isPlaying }
    var failed: Bool { manager.failed }

    init(station: RadioStation) {
        self.station = station
    }

    func start() {
        guard let url = station.preferredStreamURL else {
            return
        }
        manager.play(url: url)
    }

    func togglePlayPause() {
        if manager.isPlaying {
            manager.pause()
        } else {
            manager.resume()
        }
    }

    func stop() {
        manager.stop()
    }

    var hasStreamURL: Bool {
        station.preferredStreamURL != nil
    }
}
