#if os(Windows)
import Foundation

public final class BLEHeartRateSourceWindows: HeartRateSourceProtocol {
    public init() {}

    public func start() {
        print("BLEHeartRateSource start (Windows)")
    }

    public func stop() {
        print("BLEHeartRateSource stop (Windows)")
    }
}
#endif
