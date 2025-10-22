#if canImport(SwiftUI)
import SwiftUI
import appleMyCore // Viktigt för att få tillgång till HRVSample och HealthEngineImpl

struct HRVView: View {
    @State private var hrvSample: HRVSample?
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Heart Rate Variability")
                .font(.title2)
                .bold()

            if isLoading {
                ProgressView("Laddar HRV...")
            } else if let sample = hrvSample {
                VStack(spacing: 8) {
                    Text("SDNN: \(Int(sample.sdnn)) ms")
                    Text("Tidpunkt: \(formatted(sample.timestamp))")
                        .foregroundColor(.gray)
                }
            } else {
                Text("Ingen HRV-data tillgänglig")
                    .foregroundColor(.red)
            }

            Button("Uppdatera") {
                loadHRV()
            }
        }
        .padding()
        .onAppear {
            loadHRV()
        }
    }

    private func loadHRV() {
        isLoading = true
        HealthEngineImpl.fetchLatestHRVSample { sample in
            DispatchQueue.main.async {
                self.hrvSample = sample
                self.isLoading = false
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
#endif
