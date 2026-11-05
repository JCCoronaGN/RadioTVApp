import Foundation

@MainActor
@Observable
final class RadioListViewModel {
    private(set) var state: LoadState<[RadioStation]> = .idle
    private let service = RadioService()
    private var hasLoaded = false

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await load()
    }

    func load() async {
        state = .loading
        do {
            let stations = try await service.fetchStations()
            if stations.isEmpty {
                state = .empty("No hay estaciones disponibles en este momento.")
            } else {
                state = .loaded(stations)
            }
        } catch {
            state = .failed("No se pudo cargar la lista de radio. Revisa tu conexión o la API key.")
        }
    }
}
