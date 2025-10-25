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

    public func fetchLatestHRVSample(completion: @escaping (HRVSample?) -> Void) {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil)
            return
        }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: hrvType, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }

            let value = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
            let timestamp = sample.endDate
            let hrvSample = HRVSample(timestamp: timestamp, value: value, source: ".appleHealth")
            completion(hrvSample)
        }

        store.execute(query)
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
