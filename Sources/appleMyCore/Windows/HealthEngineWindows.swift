#if os(Windows)
import Foundation

public final class HealthEngineWindows: HealthEngineProtocol {
    public init() {}

    public func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }

    public func saveHR(_ sample: HRSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }

    public func saveHRV(_ sample: HRVSample, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
#endif
