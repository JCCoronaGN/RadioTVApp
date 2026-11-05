import Foundation
import AVKit

@MainActor
@Observable
final class VideoPlayerViewModel {
    let channel: TVChannel
    private(set) var player: AVPlayer?
    private(set) var failed = false
    private var statusObservation: NSKeyValueObservation?

    init(channel: TVChannel) {
        self.channel = channel
    }

    func start() {
        stop()
        failed = false
        let item = AVPlayerItem(url: channel.streamURL)
        let player = AVPlayer(playerItem: item)
        self.player = player

        statusObservation = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            Task { @MainActor in
                guard let self else { return }
                if item.status == .failed {
                    self.failed = true
                }
            }
        }

        player.play()
    }

    func stop() {
        statusObservation?.invalidate()
        statusObservation = nil
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
}
