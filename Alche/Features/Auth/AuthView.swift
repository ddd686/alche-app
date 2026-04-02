import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = AuthViewModel()
    @State private var showGDPRConsent = false

    var body: some View {
        ZStack {
            Color.alcheBackground.ignoresSafeArea()

            VStack(spacing: AlcheSpacing.xl) {
                Spacer()

                // Brand mark
                VStack(spacing: AlcheSpacing.md) {
                    Text("alche")
                        .font(.displayXL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("Your longevity, daily.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                Spacer()

                // Auth actions
                VStack(spacing: AlcheSpacing.md) {
                    // Apple Sign In
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        Task {
                            await viewModel.handleAppleSignIn(result)
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))

                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.alcheWarmGray)
                            .frame(height: 1)
                        Text("or")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                        Rectangle()
                            .fill(Color.alcheWarmGray)
                            .frame(height: 1)
                    }

                    // Email sign in
                    VStack(spacing: AlcheSpacing.sm) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.alcheSurface)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))

                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .padding()
                            .background(Color.alcheSurface)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }

                    Button {
                        showGDPRConsent = true
                    } label: {
                        Text(viewModel.isNewUser ? "Create Account" : "Sign In")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheSurface)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.alchePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                    .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.5 : 1)

                    Button {
                        viewModel.isNewUser.toggle()
                    } label: {
                        Text(viewModel.isNewUser ? "Already have an account? Sign in" : "New here? Create an account")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }

                // Error display
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.error)
                        .multilineTextAlignment(.center)
                }

                Spacer()
                    .frame(height: AlcheSpacing.xl)
            }
            .padding(.horizontal, AlcheSpacing.lg)

            if viewModel.isLoading {
                Color.alcheEditorialBlack.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .tint(Color.alchePrimary)
                    .scaleEffect(1.2)
            }
        }
        .sheet(isPresented: $showGDPRConsent) {
            GDPRConsentView { consents in
                viewModel.gdprConsents = consents
                Task {
                    await viewModel.signInWithEmail()
                    if viewModel.isAuthenticated {
                        appState.isAuthenticated = true
                    }
                }
            }
        }
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in
            if authenticated {
                appState.isAuthenticated = true
            }
        }
    }
}

#Preview {
    AuthView()
        .environment(AppState())
}
