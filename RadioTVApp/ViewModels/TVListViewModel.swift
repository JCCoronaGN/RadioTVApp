import Foundation

@MainActor
@Observable
final class TVListViewModel {
    private(set) var state: LoadState<[TVChannel]> = .idle
    private let service = TVService()
    private var hasLoaded = false

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await load()
    }

    func load() async {
        state = .loading
        do {
            let channels = try await service.fetchChannels()
            if channels.isEmpty {
                state = .empty("No hay canales disponibles en este momento.")
            } else {
                state = .loaded(channels)
            }
        } catch {
            state = .failed("No se pudo cargar la lista de TV. Revisa tu conexión.")
        }
    }
}
