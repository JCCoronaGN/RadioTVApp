import Foundation

struct RadioResponse: Decodable {
    let data: [RadioStation]
}

struct RadioStation: Decodable, Identifiable {
    let id: Int
    let name: String
    let genre: Genre?
    let location: Location?
    let streams: [RadioStream]?

    struct Genre: Decodable {
        let text: String?
    }

    struct Location: Decodable {
        let countryName: String?
    }

    var genreText: String {
        let value = genre?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (value?.isEmpty == false) ? value! : "Sin género"
    }

    var countryText: String {
        let value = location?.countryName?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (value?.isEmpty == false) ? value! : "Sin país"
    }

    var preferredStreamURL: URL? {
        guard let streams, !streams.isEmpty else { return nil }
        let sorted = streams.sorted { lhs, rhs in
            let lhsScore = (lhs.works == true ? 2 : 0) + (lhs.isHttps == true ? 1 : 0)
            let rhsScore = (rhs.works == true ? 2 : 0) + (rhs.isHttps == true ? 1 : 0)
            return lhsScore > rhsScore
        }
        for stream in sorted {
            if let urlString = stream.url, let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }
}

struct RadioStream: Decodable {
    let url: String?
    let isHttps: Bool?
    let codec: String?
    let bitrate: Int?
    let works: Bool?
}
