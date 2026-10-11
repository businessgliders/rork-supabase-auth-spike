import SwiftUI
import Supabase

struct ContentView: View {
    @State private var auth: AuthViewModel = AuthViewModel()

    var body: some View {
        Group {
            if !auth.isReady {
                ProgressView()
            } else if auth.session != nil {
                HomeView(auth: auth)
            } else {
                LoginView(auth: auth)
            }
        }
        .onAppear { auth.startListening() }
    }
}
