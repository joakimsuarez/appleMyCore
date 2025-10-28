#if os(Windows)
import Foundation

public class HealthEngineWindows: HealthEngineProtocol {
    public init() {}

    public func fetchSamples(
        ofType type: String,
        fromDate: Date? = nil,
        toDate: Date? = nil,
        completion: @escaping ([HealthDataSample]) -> Void
    ) {
        let samples = HealthExportReader.filterSamples(
            type: type,
            fromDate: fromDate,
            toDate: toDate
        )
        completion(samples)
    }
}
#endif
