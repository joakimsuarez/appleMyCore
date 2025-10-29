//
//  HRVViewiPhone.swift
//
//


#if canImport(SwiftUI)
#Preview {
    MainViewiPhone()
        .padding()
        .previewDevice("iPhone 15 Pro")
}

import SwiftUI


public struct MainViewiPhone: View {
    public init() {}
    @State private var sample: HealthDataSample?
	@State private var isLoading = true
    private var engine: HealthEngineImpl	 = HealthEngineImpl()

    public var body: some View {
        VStack(spacing: 16) {
            Text("Heart Data")
                .font(.title2)
                .bold()

            if isLoading {
                ProgressView("Laddar data...")
            } else if let sample = sample {
                
                
                
                
                
                VStack(spacing: 8) {
                    Text("HRV: \(Int(sample.value)) ms")
                    Text("Tidpunkt: \(formatted(sample.timestamp))")
                        .foregroundColor(.gray)
                    Text("SOURCE: \(sample.source) ")
                }
            } else {
                Text("Ingen HRV-data tillgänglig")
                    .foregroundColor(.red)
            }

            Button("Uppdatera") {
                loadHealthData()
            }
        }
        .padding()
        .onAppear {
            loadHealthData()
        }
    }


    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
    
    
    private func loadHealthData() {
        isLoading = true
        let type = "HeartRateVariabilitySDNN"
        let fromDate = parseDate("2025-10-01")
        let toDate: Date? = nil
        	
        engine.fetchSamples(ofType: type, fromDate: fromDate, toDate: toDate) { samples in
            if samples.isEmpty {
                print("Inga matchande \(type)-samples hittades.")
                DispatchQueue.main.async {
                     self.isLoading = false
                }
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

            DispatchQueue.main.async {
                self.sample = samples.first
                self.isLoading = false
            }
        }
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: string)
    }
    

}
#endif
