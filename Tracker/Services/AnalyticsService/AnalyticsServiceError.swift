import Foundation

enum AnalyticsServiceError: Error {
    case invalidApiKey
    
    var localizedDescription: String {
        switch self {
        case .invalidApiKey:
            return "Invalid API key"
        }
    }
}
