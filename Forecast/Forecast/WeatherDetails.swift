import SwiftUI

struct WeatherDetails: View{
    @Binding var results: [ForecastDay]
    @Binding var cityName: String
    var index: Int
    
    var body: some View{
        Text("hello")
    }
}

#Preview {
    WeatherDetails()
}
