import SwiftUI

struct LoginView: View {
    let auth: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                Section {
                    Button {
                        Task { await auth.signIn(email: email, password: password) }
                    } label: {
                        if auth.isWorking {
                            ProgressView()
                        } else {
                            Text("Sign in")
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || auth.isWorking)
                }
                if let error = auth.errorMessage {
                    Section("Error") {
                        Text(error).foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Sign in")
        }
    }
}
