#if os(macOS) || os(iOS) || os(watchOS)
import Foundation
import HealthKit
import appleMyCore

public class HealthEngineApple: HealthEngineProtocol {
    private let healthStore = HKHealthStore()
    private var hasRequestedAuthorization = false

    public init() {}



    public func fetchSamples(
        ofType type: String,
        fromDate: Date? = nil,
        toDate: Date? = nil,
        completion: @escaping ([HealthDataSample]) -> Void
    ) {
        #if targetEnvironment(simulator)
        let samples = HealthExportReader.filterSamples(
            type: type,
            fromDate: fromDate,
            toDate: toDate
        )
        completion(samples)

        #else
        guard HKHealthStore.isHealthDataAvailable() else {
            completion([])
            return
        }

        ensureAuthorization(for: type) { authorized in
            guard authorized else {
                completion([])
                return
            }

            guard let quantityType = HKObjectType.quantityType(forIdentifier: self.hkIdentifier(for: type)) else {
                completion([])
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, results, error in
                guard let quantitySamples = results as? [HKQuantitySample], error == nil else {
                    completion([])
                    return
                }

                let mapped = quantitySamples.map {
                    HealthDataSample(
                        timestamp: $0.startDate,
                        value: $0.quantity.doubleValue(for: self.unit(for: type)),
                        type: type,
                        source: $0.sourceRevision.source.name
                    )
                }

                completion(mapped)
            }

            self.healthStore.execute(query)
        }
        #endif
    }

    private func ensureAuthorization(for type: String, completion: @escaping (Bool) -> Void) {
        guard !hasRequestedAuthorization else {
            completion(true)
            return
        }

        guard let quantityType = HKObjectType.quantityType(forIdentifier: hkIdentifier(for: type)) else {
            completion(false)
            return
        }

        healthStore.requestAuthorization(toShare: [], read: [quantityType]) { success, _ in
            self.hasRequestedAuthorization = success
            completion(success)
        }
    }

    private func hkIdentifier(for type: String) -> HKQuantityTypeIdentifier {
        switch type {
        case "HeartRate": return .heartRate
        case "StepCount": return .stepCount
        case "HRV": return .heartRateVariabilitySDNN
        default: return .stepCount
        }
    }

    private func unit(for type: String) -> HKUnit {
        switch type {
        case "HeartRate": return HKUnit.count().unitDivided(by: HKUnit.minute())
        case "StepCount": return HKUnit.count()
        case "HRV": return HKUnit.secondUnit(with: .milli)
        default: return HKUnit.count()
        }
    }
}
#endif