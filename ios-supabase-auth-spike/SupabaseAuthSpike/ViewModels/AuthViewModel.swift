import Foundation
import Observation
import Supabase

/// Drives Login/Home switching purely from `authStateChanges`.
@Observable
final class AuthViewModel {
    var session: Session?
    var isReady: Bool = false
    var errorMessage: String?
    var isWorking: Bool = false

    private var listenTask: Task<Void, Never>?

    func startListening() {
        guard listenTask == nil else { return }
        listenTask = Task { [weak self] in
            for await (event, session) in SupabaseService.client.auth.authStateChanges {
                guard let self else { return }
                print("[Auth] event: \(event.rawValue), hasSession: \(session != nil)")
                switch event {
                case .initialSession:
                    if let session, session.isExpired {
                        // Stored session's access token expired; SDK refreshes it using the refresh token.
                        do {
                            self.session = try await SupabaseService.client.auth.session
                        } catch {
                            self.session = nil
                        }
                    } else {
                        self.session = session
                    }
                    self.isReady = true
                case .signedOut:
                    self.session = nil
                default:
                    self.session = session
                }
            }
        }
    }

    func signIn(email: String, password: String) async {
        errorMessage = nil
        isWorking = true
        defer { isWorking = false }
        do {
            try await SupabaseService.client.auth.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await SupabaseService.client.auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
