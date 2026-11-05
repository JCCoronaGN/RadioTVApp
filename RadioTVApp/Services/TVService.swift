import Foundation

struct TVService {
    func fetchChannels() async throws -> [TVChannel] {
        guard let url = URL(string: APIConfig.tvM3UURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        guard let content = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }

        return parseM3U(content)
    }

    private func parseM3U(_ content: String) -> [TVChannel] {
        let lines = content.components(separatedBy: .newlines)
        var channels: [TVChannel] = []
        var pendingName: String?

        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if line.hasPrefix("#EXTINF") {
                // El nombre está después de la última coma.
                if let commaIndex = line.lastIndex(of: ",") {
                    let name = String(line[line.index(after: commaIndex)...])
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    pendingName = name.isEmpty ? "Canal sin nombre" : name
                }
            } else if !line.isEmpty, !line.hasPrefix("#"), let name = pendingName {
                if let url = URL(string: line) {
                    channels.append(TVChannel(name: name, streamURL: url))
                }
                pendingName = nil
            }
        }

        return channels
    }
}
