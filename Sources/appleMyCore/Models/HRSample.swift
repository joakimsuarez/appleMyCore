import Foundation

public struct HRSample: Codable, Equatable {
    public let bpm: Int
    public let timestamp: Date

    public init(bpm: Int, timestamp: Date = Date()) {
        self.bpm = bpm
        self.timestamp = timestamp
    }
}
