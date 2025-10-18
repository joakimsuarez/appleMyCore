import Foundation

public protocol HealthEngineProtocol {
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    func saveHR(_ sample: HRSample, completion: @escaping (Bool, Error?) -> Void)
    func saveHRV(_ sample: HRVSample, completion: @escaping (Bool, Error?) -> Void)
}
