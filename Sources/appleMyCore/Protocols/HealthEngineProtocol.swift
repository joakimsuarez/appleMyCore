import Foundation

public protocol HealthEngineProtocol {
    func fetchSamples(ofType type: String, fromDate: Date?, toDate: Date?, completion: @escaping ([HealthDataSample]) -> Void)
}
