#if canImport(HealthKit)
public typealias HealthEngineImpl = HealthEngineApple
public typealias BLEHeartRateSourceImpl = BLEHeartRateSourceApple
#elseif os(Windows)
public typealias HealthEngineImpl = HealthEngineWindows
public typealias BLEHeartRateSourceImpl = BLEHeartRateSourceWindows
#endif
