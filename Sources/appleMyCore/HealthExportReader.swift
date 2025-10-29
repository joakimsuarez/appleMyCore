import Foundation
import SWXMLHash

public class HealthExportReader {
    public static func filterSamples(
        type filterType: String,
        fromDate: Date? = nil,
        toDate: Date? = nil,
        limit: Int? = nil
    ) -> [HealthDataSample] {

        guard let path = Bundle.module.path(forResource: "export", ofType: "xml"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("export.xml not found")
            return []
        }

        // will use the appleMyCore parse function
        let xml = XMLHash.parse(data)

        var results: [HealthDataSample] = []

        for elem in xml["HealthData"]["Record"].all {
            guard let typeAttr = elem.element?.attribute(by: "type")?.text,
                  typeAttr.hasSuffix(filterType),
                  let valueStr = elem.element?.attribute(by: "value")?.text,
                  let value = Double(valueStr),
                  let source = elem.element?.attribute(by: "sourceName")?.text,
                  let dateStr = elem.element?.attribute(by: "startDate")?.text,
                  let date = dateFormatter.date(from: dateStr)
            else { continue }

            if let from = fromDate, date < from { continue }
            if let to = toDate, date > to { continue }

            results.append(HealthDataSample(timestamp: date, value: value, type: filterType, source: source))

            if let limit = limit, results.count >= limit {
                break
            }
        }
        /* --- if need to hard code to test
            guard let date = dateFormatter.date(from: "2025-10-09 09:25:42 +0200") else {
                print("Invalid date format")
                return []
            }
            var results: [HealthDataSample] = []
            results.append(HealthDataSample(timestamp: date, value: 66.9498, type: "HKQuantityTypeIdentifierHeartRateVariabilitySDNN", source: "Apple Watch för Joakim"))
        */
        return results
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
