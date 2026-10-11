import Foundation
import Observation
import Supabase

@Observable
final class ItemsViewModel {
    var items: [MyItem] = []
    var errorMessage: String?
    var isLoading: Bool = false

    /// Selects all rows; row-level security on the database decides what comes back.
    func load() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let rows: [MyItem] = try await SupabaseService.client
                .from("my_items")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            items = rows
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func add(title: String) async -> Bool {
        errorMessage = nil
        do {
            let user = try await SupabaseService.client.auth.session.user
            try await SupabaseService.client
                .from("my_items")
                .insert(NewItem(title: title, userId: user.id))
                .execute()
            await load()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
