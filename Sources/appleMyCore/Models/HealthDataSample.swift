import Foundation

public struct HealthDataSample: Codable, Equatable {
    public let timestamp: Date
    public let value: Double
    public let type: String
    public let source: String

    public init(timestamp: Date = Date(), value: Double, type: String, source: String) {
        self.timestamp = timestamp
        self.value = value
        self.type = type
        self.source = source
    }
}

