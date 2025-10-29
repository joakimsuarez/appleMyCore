#if os(Windows)
import Foundation
import appleMyCore
import SWXMLHash

@main
// Run by: swift run appleMyCoreCLI StepCount --from 2025-10-01
struct Main {
    static func main()  {
        
        let args = CommandLine.arguments.dropFirst() // skip executable name

        guard let typeArg = args.first else {
            print("Ange typ, t.ex. HeartRate eller StepCount")
            return
        }

        let type = typeArg
        let fromDate = parseDateArg(flag: "--from", args: args)
        let toDate = parseDateArg(flag: "--to", args: args)

        let engine = HealthEngineImpl()
        // Async därfär behövs completion handler
        engine.fetchSamples(ofType: type, fromDate: fromDate, toDate: toDate) { samples in
            if samples.isEmpty {
                print("Inga matchande \(type)-samples hittades.")
                return
            }
            // deictionary array där string är nyckel och en array med double =[:] betyder skapa en ny tom deictionary
            var dailyHRVValues: [String: [Double]] = [:]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            for sample in samples {
                guard sample.type == "HeartRateVariabilitySDNN",
                    sample.value > 0 else {
                    continue
                }
                let dayKey = formatter.string(from: sample.timestamp)
                dailyHRVValues[dayKey, default: []].append(sample.value)
                //dailyHRV[dayKey, default: 0.0] += sample.value
                print("\(type): \(Int(sample.value)) @ \(formatted(sample.timestamp)) från \(sample.source)")
            }

            for (day, values) in dailyHRVValues.sorted(by: { $0.key < $1.key }) {
                let min = values.min() ?? 0
                let max = values.max() ?? 0
                let avg = values.reduce(0, +) / Double(values.count)

                print("📅 \(day): min \(Int(min)) ms, medel \(Int(avg)) ms, max \(Int(max)) ms (\(values.count) samples)")
            }
        }

        RunLoop.main.run(until: Date().addingTimeInterval(2)) 
    }

    private static func parseDateArg(flag: String, args: ArraySlice<String>) -> Date? {
        guard let index = args.firstIndex(of: flag),
              args.indices.contains(index + 1) else { return nil }

        let dateStr = args[index + 1]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateStr)
    }

    private static func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
#endif
