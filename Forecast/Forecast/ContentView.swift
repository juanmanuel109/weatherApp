import SwiftUI

struct Wheather: Codable {
    var location: Location
}
struct Location: Codable {
    var name: String
}
struct Forecast: Codable {
    var forecastday : [Forecast]
}

struct ForecastDay: Codable, Identifiable {
    var date_epoch: Int
    var id: Int{date_epoch}
}

struct Day: Codable {
    var avgtemp_c : Double
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
