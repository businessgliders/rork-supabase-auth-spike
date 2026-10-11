import SwiftUI
import Supabase

struct HomeView: View {
    let auth: AuthViewModel
    @State private var viewModel: ItemsViewModel = ItemsViewModel()
    @State private var newTitle: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Signed in as") {
                    Text(auth.session?.user.email ?? "(no email)")
                }
                Section("Add item") {
                    HStack {
                        TextField("Title", text: $newTitle)
                        Button("Add item") {
                            let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                            Task {
                                if await viewModel.add(title: title) { newTitle = "" }
                            }
                        }
                        .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                if let error = viewModel.errorMessage {
                    Section("Error") {
                        Text(error).foregroundStyle(.red)
                    }
                }
                Section("my_items (\(viewModel.items.count))") {
                    if viewModel.items.isEmpty && !viewModel.isLoading {
                        Text("No rows returned").foregroundStyle(.secondary)
                    }
                    ForEach(viewModel.items) { item in
                        Text(item.title ?? "(no title)")
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign out") {
                        Task { await auth.signOut() }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Refresh") {
                            Task { await viewModel.load() }
                        }
                    }
                }
            }
            .task { await viewModel.load() }
        }
    }
}
