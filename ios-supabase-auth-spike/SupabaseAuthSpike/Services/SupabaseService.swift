import Foundation
import Supabase

/// Single shared Supabase client. Session persistence (Keychain) and automatic
/// token refresh are handled entirely by the SDK's defaults.
enum SupabaseService {
    static let client: SupabaseClient = SupabaseClient(
        supabaseURL: URL(string: "https://ouckdjvsxozksskinkzf.supabase.co")!,
        supabaseKey: "sb_publishable_lWYfvJy52Edv2IONcibzRg_8KfJOvTG",
        options: SupabaseClientOptions(
            auth: SupabaseClientOptions.AuthOptions(
                autoRefreshToken: true,
                emitLocalSessionAsInitialSession: true
            )
        )
    )
}
