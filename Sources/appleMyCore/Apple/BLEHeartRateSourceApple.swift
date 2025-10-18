#if canImport(CoreBluetooth)
import Foundation
import CoreBluetooth

public class BLEHeartRateSourceApple: NSObject, HeartRateSource {
    public func start() {
        print("BLEHeartRateSource start (Apple)")
    }

    public func stop() {
        print("BLEHeartRateSource stop (Apple)")
    }
}
#endif
