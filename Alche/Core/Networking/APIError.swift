import Foundation

enum APIError: LocalizedError, Sendable {
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case networkUnavailable
    case decodingFailed(underlying: String)
    case invalidRequest(reason: String)
    case rateLimited
    case unknown(underlying: String)

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            "Please sign in to continue."
        case .notFound:
            "We couldn't find what you're looking for."
        case .serverError(let code):
            "Something went wrong on our end (code \(code)). Please try again."
        case .networkUnavailable:
            "No internet connection. Check your connection and try again."
        case .decodingFailed:
            "We had trouble reading the response. Please try again."
        case .invalidRequest(let reason):
            reason
        case .rateLimited:
            "Too many requests. Please wait a moment and try again."
        case .unknown:
            "Something unexpected happened. Please try again."
        }
    }

    var isRetryable: Bool {
        switch self {
        case .serverError, .networkUnavailable, .rateLimited:
            true
        default:
            false
        }
    }
}
