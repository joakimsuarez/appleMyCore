#if canImport(HealthKit)
import Foundation
import HealthKit

public final class HealthEngineApple: HealthEngineProtocol {
    private let store = HKHealthStore()

    public init() {}

    public func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let types: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]
        store.requestAuthorization(toShare: types, read: types) { success, error in
            completion(success, error)
        }
    }

    public func saveHR(_ sample: HRSample, completion: @escaping (Bool, Error?) -> Void) {
        // Implementera med HKQuantitySample för heart rate
        completion(true, nil) // stub
    }

    public func saveHRV(_ sample: HRVSample, completion: @escaping (Bool, Error?) -> Void) {
        // Implementera med HKQuantitySample för HRV
        completion(true, nil) // stub
    }
}
#endif
