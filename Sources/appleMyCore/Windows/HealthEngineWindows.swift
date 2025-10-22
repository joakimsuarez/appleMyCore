#if os(Windows)
import Foundation

public final class HealthEngineWindows: HealthEngineProtocol {
    public init() {}

    public func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }

    public func fetchLatestHRVSample(completion: @escaping (HRVSample?) -> Void) {
        // Returnera ett dummyvärde för testsyfte
        let mockSample = HRVSample(
            sdnn: 42.0,
            timestamp: Date(),
            source: "Windows get data"
        )
        completion(mockSample)
    }

    public func saveHR(_ sample: HRSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }

    public func saveHRV(_ sample: HRVSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
#endif
