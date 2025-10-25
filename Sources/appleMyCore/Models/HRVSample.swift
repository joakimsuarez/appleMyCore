import Foundation

public struct HRVSample: Codable, Equatable {
    public let value: Double
    public let timestamp: Date
    public let source: String

    public init(timestamp: Date = Date(), value: Double, source: String) {
        self.value = value
        self.timestamp = timestamp
        self.source = source
    }
}
