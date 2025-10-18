public protocol HeartRateMonitorProtocol {
    func begin()
    func saveHR(sample: HRSample, completion: @escaping (Bool, Error?) -> Void)
    func saveHRV(sample: HRVSample, completion: @escaping (Bool, Error?) -> Void)
    func end()
}
