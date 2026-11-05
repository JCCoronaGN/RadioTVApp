import Foundation

@MainActor
@Observable
final class SessionManager {
    private(set) var isLoggedIn: Bool

    // Usuario fijo definido en código (reemplaza los valores).
    private let validUser = "USUARIO"
    private let validPassword = "CONTRASEÑA"

    init() {
        self.isLoggedIn = KeychainService.hasActiveSession()
    }

    func login(user: String, password: String) -> Bool {
        guard user == validUser, password == validPassword else {
            return false
        }
        KeychainService.saveSession()
        isLoggedIn = true
        return true
    }

    func logout() {
        KeychainService.clearSession()
        isLoggedIn = false
    }
}
