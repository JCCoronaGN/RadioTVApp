import Foundation

struct RadioService {
    func fetchStations() async throws -> [RadioStation] {
        guard let url = URL(string: APIConfig.radioURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConfig.rapidAPIHost, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(APIConfig.rapidAPIKey, forHTTPHeaderField: "x-rapidapi-key")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(RadioResponse.self, from: data)
        return decoded.data
    }
}
