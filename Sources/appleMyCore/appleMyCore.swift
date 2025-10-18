import Foundation
public struct HeartRateSample: Codable, Equatable {
    public let bpm: Int
    public let timestamp: Date
public init(bpm: Int, timestamp: Date = Date()) {
        self.bpm = bpm
        self.timestamp = timestamp
    }
}
public protocol HeartRateSource {
    func start()
    func stop()
}
public protocol HealthEngineProtocol {
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    func saveHeartRate(_ sample: HeartRateSample, completion: @escaping (Bool, Error?) -> Void)
}
#if canImport(HealthKit)
import HealthKit
public final class HealthEngine: HealthEngineProtocol {
    public init() {}
    public func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
    public func saveHeartRate(_ sample: HeartRateSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
#else
public final class HealthEngine: HealthEngineProtocol {
    public init() {}
    public func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
    public func saveHeartRate(_ sample: HeartRateSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
#endif
#if canImport(CoreBluetooth)
import CoreBluetooth
public class BLEHeartRateSource: NSObject, HeartRateSource {
    public func start() {}
    public func stop() {}
}
#else
public final class BLEHeartRateSource: HeartRateSource {
    public init() {}
    public func start() { print("BLEHeartRateSource.start() stub") }
    public func stop() { print("BLEHeartRateSource.stop() stub") }
}
#endif
public final class HeartRateManager {
    private let source: HeartRateSource
    private let engine: HealthEngineProtocol
public init(source: HeartRateSource, engine: HealthEngineProtocol) {
        self.source = source
        self.engine = engine
    }
public func begin() { source.start() }
    public func save(sample: HeartRateSample, completion: @escaping (Bool, Error?) -> Void) {
        engine.saveHeartRate(sample, completion: completion)
    }
}
