

import SwiftUI

struct Wheather: Codable {
    var location: Location
}
struct Location: Codable {
    var name: String
}
struct Forecast: Codable {
    
}

struct ForecastDay: Codable {
    
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
