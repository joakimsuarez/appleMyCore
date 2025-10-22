import Foundation

public struct HRVSample: Codable, Equatable {
    public let sdnn: Double
    public let timestamp: Date
    public let source: String

    public init(sdnn: Double, timestamp: Date = Date(), source: String) {
        self.sdnn = sdnn
        self.timestamp = timestamp
        self.source = source
    }
}
