import Foundation

struct TVChannel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let streamURL: URL
}
