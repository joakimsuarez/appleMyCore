import Foundation

public struct HRVSample: Codable, Equatable {
    public let sdnn: Double
    public let timestamp: Date

    public init(sdnn: Double, timestamp: Date = Date()) {
        self.sdnn = sdnn
        self.timestamp = timestamp
    }
}
