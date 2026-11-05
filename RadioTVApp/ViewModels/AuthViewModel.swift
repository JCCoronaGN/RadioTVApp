import Foundation

@MainActor
@Observable
final class AuthViewModel {
    var username = ""
    var password = ""
    private(set) var errorMessage: String?

    func login(using session: SessionManager) {
        let ok = session.login(user: username, password: password)
        errorMessage = ok ? nil : "Usuario o contraseña incorrectos."
        if ok {
            password = ""
        }
    }
}
