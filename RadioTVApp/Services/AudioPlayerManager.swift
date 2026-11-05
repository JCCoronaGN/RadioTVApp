import Foundation
import AVFoundation

@MainActor
@Observable
final class AudioPlayerManager {
    private(set) var isPlaying = false
    private(set) var failed = false
    private var player: AVPlayer?
    private var statusObservation: NSKeyValueObservation?

    func play(url: URL) {
        stop()
        failed = false

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            failed = true
            return
        }

        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        self.player = player

        statusObservation = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            Task { @MainActor in
                guard let self else { return }
                if item.status == .failed {
                    self.failed = true
                    self.isPlaying = false
                }
            }
        }

        player.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        guard player != nil, !failed else { return }
        player?.play()
        isPlaying = true
    }

    func stop() {
        statusObservation?.invalidate()
        statusObservation = nil
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        isPlaying = false
    }
}
