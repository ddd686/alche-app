import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

enum QRGenerator {

    /// Generates a QR code UIImage from a string payload.
    /// Used for booking check-in codes.
    static func generate(from string: String, size: CGFloat = 250) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }

        let scale = size / outputImage.extent.width
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    /// Generates a unique booking QR code string.
    /// Format: ALCHE-{short UUID}-{timestamp}
    static func bookingCode(bookingId: UUID) -> String {
        let shortId = bookingId.uuidString.prefix(8).uppercased()
        let timestamp = Int(Date().timeIntervalSince1970) % 100000
        return "ALCHE-\(shortId)-\(timestamp)"
    }
}
