import Foundation
import AuthenticationServices

struct GDPRConsents: Sendable {
    var essentialData: Bool = true // Always required
    var healthData: Bool = false
    var analytics: Bool = false
    var marketing: Bool = false
}

@Observable
@MainActor
final class AuthViewModel {
    var email = ""
    var password = ""
    var isNewUser = true
    var isLoading = false
    var errorMessage: String?
    var isAuthenticated = false
    var gdprConsents = GDPRConsents()

    // MARK: - Email Auth

    func signInWithEmail() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            if isNewUser {
                // TODO: Wire to Supabase Auth signUp
                // try await authService.signUp(email: email, password: password, consents: gdprConsents)
                try await Task.sleep(for: .seconds(1.5)) // Simulated delay
            } else {
                // TODO: Wire to Supabase Auth signIn
                // try await authService.signIn(email: email, password: password)
                try await Task.sleep(for: .seconds(1.0)) // Simulated delay
            }
            isAuthenticated = true
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }

        isLoading = false
    }

    // MARK: - Apple Sign In

    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        isLoading = true
        errorMessage = nil

        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credential.identityToken,
                  let tokenString = String(data: identityToken, encoding: .utf8) else {
                errorMessage = "Could not process Apple Sign In."
                isLoading = false
                return
            }

            do {
                // TODO: Wire to Supabase Auth signInWithApple
                // try await authService.signInWithApple(idToken: tokenString)
                _ = tokenString
                try await Task.sleep(for: .seconds(1.0)) // Simulated delay
                isAuthenticated = true
            } catch {
                errorMessage = "Apple Sign In failed. Please try again."
            }

        case .failure:
            errorMessage = "Apple Sign In was cancelled."
        }

        isLoading = false
    }

    // MARK: - Sign Out

    func signOut() async {
        // TODO: Wire to Supabase Auth signOut
        isAuthenticated = false
        email = ""
        password = ""
    }
}
