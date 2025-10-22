#if os(Windows)
import Foundation
import appleMyCore

func runCLI() {
    let engine = HealthEngineImpl()    
    engine.fetchLatestHRVSample { sample in
        if let s = sample {
            print("SDNN: \(Int(s.sdnn)) ms")
            print("Tidpunkt: \(formatted(s.timestamp))")
        } else {
            print("Ingen HRV-data tillgänglig.")
        }
    }

    RunLoop.main.run(until: Date().addingTimeInterval(1)) // Vänta på async callback
}

private func formatted(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
#endif
