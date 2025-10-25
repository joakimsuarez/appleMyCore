#if canImport(CoreBluetooth)
import Foundation
import CoreBluetooth

public class BLEHeartRateSourceApple: NSObject, HeartRateSourceProtocol {
    public func start() {
        print("BLEHeartRateSource start (Apple)")
    }		

    public func stop() {
        print("BLEHeartRateSource stop (Apple)")
    }
}
#endif
