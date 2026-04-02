import SwiftUI

struct GDPRConsentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var essentialData = true
    @State private var healthData = false
    @State private var analytics = false
    @State private var marketing = false

    var onAccept: (GDPRConsents) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("Your Data, Your Choice")
                            .font(.displayL)
                            .foregroundStyle(Color.alcheEditorialBlack)

                        Text("We take your privacy seriously. Choose what data you're comfortable sharing. You can change these settings at any time.")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }

                    // Consent toggles
                    VStack(spacing: AlcheSpacing.md) {
                        ConsentRow(
                            title: "Essential Data",
                            description: "Account information, bookings, and orders. Required to use the app.",
                            isOn: $essentialData,
                            isRequired: true
                        )

                        Divider()
                            .foregroundStyle(Color.alcheWarmGray)

                        ConsentRow(
                            title: "Health & Wellness Data",
                            description: "Daily check-ins, protocol tracking, and scan results. Helps us personalise your experience.",
                            isOn: $healthData,
                            isRequired: false
                        )

                        Divider()
                            .foregroundStyle(Color.alcheWarmGray)

                        ConsentRow(
                            title: "Analytics",
                            description: "Anonymous usage data to improve the app. No personal information is shared.",
                            isOn: $analytics,
                            isRequired: false
                        )

                        Divider()
                            .foregroundStyle(Color.alcheWarmGray)

                        ConsentRow(
                            title: "Communications",
                            description: "Protocol reminders, event updates, and new content notifications.",
                            isOn: $marketing,
                            isRequired: false
                        )
                    }
                    .padding(AlcheSpacing.md)
                    .background(Color.alcheSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))

                    // Legal links
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Link("Privacy Policy", destination: URL(string: "https://alche.com/privacy")!)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimary)

                        Link("Terms of Service", destination: URL(string: "https://alche.com/terms")!)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimary)
                    }

                    // Accept button
                    Button {
                        let consents = GDPRConsents(
                            essentialData: true,
                            healthData: healthData,
                            analytics: analytics,
                            marketing: marketing
                        )
                        onAccept(consents)
                        dismiss()
                    } label: {
                        Text("Continue")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheSurface)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.alchePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.lg)
            }
            .background(Color.alcheSurface)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        let consents = GDPRConsents(
                            essentialData: true,
                            healthData: false,
                            analytics: false,
                            marketing: false
                        )
                        onAccept(consents)
                        dismiss()
                    }
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }
}

// MARK: - Consent Row

private struct ConsentRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    let isRequired: Bool

    var body: some View {
        HStack(alignment: .top, spacing: AlcheSpacing.md) {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                HStack(spacing: AlcheSpacing.sm) {
                    Text(title)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    if isRequired {
                        Text("REQUIRED")
                            .font(.alcheOverlineTiny)
                            .tracking(0.8)
                            .foregroundStyle(Color.alchePrimary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.alchePrimary.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                    }
                }

                Text(description)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.alcheSage)
                .disabled(isRequired)
        }
    }
}

#Preview {
    GDPRConsentView { consents in
        print("Consents: \(consents)")
    }
}
