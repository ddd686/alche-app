import SwiftUI

// MARK: - Text Field Component

struct AlcheTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isSecure: Bool = false
    var icon: String? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            // Label — Space Mono uppercase
            Text(label.uppercased())
                .font(.alcheMono)
                .tracking(1.0)
                .foregroundStyle(isFocused ? Color.alchePrimary : Color.alcheEditorialMuted)

            // Input area — bottom border only, no box
            HStack(spacing: AlcheSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(isFocused ? Color.alchePrimary : Color.alcheEditorialMuted)
                        .frame(width: 20)
                }

                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(.alcheBody)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.alcheBody)
                        .focused($isFocused)
                }
            }
            .foregroundStyle(Color.alcheEditorialBlack)
            .padding(.vertical, 12)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(isFocused ? Color.alchePrimary : Color.alcheEditorialBlack.opacity(0.10))
                    .frame(height: isFocused ? 2 : 1)
            }
            .animation(.alcheQuick, value: isFocused)
        }
    }
}

// MARK: - Preview

#Preview("Text Fields") {
    VStack(spacing: AlcheSpacing.lg) {
        AlcheTextField(
            label: "Email",
            text: .constant(""),
            placeholder: "you@example.com",
            icon: "envelope"
        )

        AlcheTextField(
            label: "Password",
            text: .constant(""),
            placeholder: "Enter password",
            isSecure: true,
            icon: "lock"
        )

        AlcheTextField(
            label: "Display Name",
            text: .constant("Timu"),
            placeholder: "Your name"
        )
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
