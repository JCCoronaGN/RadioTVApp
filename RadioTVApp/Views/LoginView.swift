import SwiftUI

struct LoginView: View {
    let session: SessionManager
    @State private var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text("RadioTVApp")
                .font(.title).bold()

            @Bindable var viewModel = viewModel
            TextField("Usuario", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button("Entrar") {
                viewModel.login(using: session)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
