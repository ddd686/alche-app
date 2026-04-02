import Foundation

#warning("Replace with real Supabase credentials before Sprint 3")

enum SupabaseConfig {
    static let url = URL(string: "https://your-project.supabase.co")!
    static let anonKey = "your-anon-key-here"
}

// Supabase client wrapper.
// Requires `supabase-swift` SPM dependency to be resolved.
// Until then, this file provides the configuration and a stub interface.
//
// Usage:
//   let client = SupabaseService.shared.client
//   let profiles = try await client.from("profiles").select().execute()

@MainActor
final class SupabaseService: Sendable {
    static let shared = SupabaseService()

    // Uncomment when supabase-swift is added as a dependency:
    //
    // import Supabase
    //
    // let client: SupabaseClient
    //
    // private init() {
    //     client = SupabaseClient(
    //         supabaseURL: SupabaseConfig.url,
    //         supabaseKey: SupabaseConfig.anonKey
    //     )
    // }

    private init() {}
}
