#if canImport(SwiftUI)
import SwiftUI

@main
struct iPhoneApp: App {
    var body: some Scene {
        WindowGroup {
            HRVView()
        }
    }
}
#else
@main
struct iPhoneApp {
    static func main() {
        print("Running on Windows")
        // Din CLI eller GUI-logik här
    }
}
#endif
