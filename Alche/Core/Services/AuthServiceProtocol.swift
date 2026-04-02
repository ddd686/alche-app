import Foundation

protocol AuthServiceProtocol: Sendable {
    func signInWithEmail(email: String, password: String) async throws -> AlcheUser
    func signUpWithEmail(email: String, password: String) async throws -> AlcheUser
    func signInWithApple(identityToken: Data, nonce: String) async throws -> AlcheUser
    func signOut() async throws
    func resetPassword(email: String) async throws
    func deleteAccount() async throws
    func currentUser() async -> AlcheUser?
    func updateProfile(_ user: AlcheUser) async throws -> AlcheUser
}
