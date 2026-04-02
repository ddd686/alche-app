import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCheckInView: View {
    let booking: Booking
    @State private var brightness: CGFloat = UIScreen.main.brightness

    var body: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            // Session info
            VStack(spacing: AlcheSpacing.sm) {
                Text(booking.sessionType?.displayName ?? "Session")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alchePrimary)

                Text(formattedDateTime(booking.slotStart))
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)
            }

            // QR code
            if let qrCode = booking.qrCode, let qrImage = generateQRCode(from: qrCode) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .padding(AlcheSpacing.lg)
                    .background(Color.alcheWhite)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.lg))
                    .shadow(color: Color.alchePrimaryText.opacity(0.08), radius: 16, y: 4)
            }

            // Code text
            if let qrCode = booking.qrCode {
                Text(qrCode)
                    .font(.alcheMono)
                    .foregroundStyle(Color.alcheSecondaryText)
            }

            Text("Show this code at the entrance")
                .font(.alcheBody)
                .foregroundStyle(Color.alcheSecondaryText)

            Spacer()

            // Status indicator
            HStack(spacing: AlcheSpacing.sm) {
                Circle()
                    .fill(booking.isUpcoming ? Color.alcheSuccess : Color.alcheSecondaryText)
                    .frame(width: 8, height: 8)

                Text(booking.isUpcoming ? "Ready for check-in" : "Session \(booking.status.rawValue)")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
            .padding(.bottom, AlcheSpacing.lg)
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .background(Color.alcheBackground)
        .navigationTitle("Check In")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Boost brightness for QR scanning
            brightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
        }
        .onDisappear {
            UIScreen.main.brightness = brightness
        }
    }

    // MARK: - QR Generation

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }

        let scale = 10.0
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d MMM"
        let dayString = dayFormatter.string(from: date)

        return "\(dayString) at \(timeString)"
    }
}

#Preview {
    NavigationStack {
        QRCheckInView(booking: .preview)
    }
}
