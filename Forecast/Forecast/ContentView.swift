import SwiftUI
import Alamofire



struct ContentView: View {
    
    @State private var results = [ForecastDay]()
    
    
    @State var backgroundColor = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    @State var weatherEmoji = "☀️"
    @State var currentTemp = 0
    @State var conditionText = "Slightly Overcast"
    @State var cityName = "Toronto"
    @State var loading = true
    
    
    var body: some View {
        if loading {
            ZStack {
               Color.init(backgroundColor)
                .ignoresSafeArea()
               ProgressView()
                .scaleEffect(2, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task {
                    await fetchWeather()
                    }
               }
            
        } else {
        VStack {
            Spacer()
            Text("\(cityName)")
                .font(.system(size: 35))
                .foregroundStyle(.white)
                .bold()
            Text("\(Date().formatted(date:.complete,time:.omitted))")
                .foregroundStyle(.white)
                .font(.system(size: 18))
            Text(weatherEmoji)
                .font(.system(size: 180))
                .shadow(radius: 75)
            Text("\(currentTemp)°C")
                .foregroundStyle(.white)
                .font(.system(size: 70))
                .bold()
            Text("\(conditionText)")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .bold()
            Spacer()
            Spacer()
            Spacer()
            List(results){ forecast in
                HStack(alignment: .center, spacing: nil){
                    Text("\(getShortDate(epoch: forecast.date_epoch))")
                        .frame(maxWidth: 50, alignment: .leading)
                        .bold()
                    Text("\(getWeatherEmoji(code: forecast.day.condition.code))")
                        .frame(maxWidth: 30, alignment: .leading)
                    Text("\(Int(forecast.day.avgtemp_c))°C")
                        .frame(maxWidth: 50, alignment: .leading)
                    Spacer()
                    Text("\(forecast.day.condition.text)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color.white.blur(radius: 75).opacity(0.5))
            }
            .contentMargins(.vertical, 0)
            .scrollContentBackground(.hidden)
            .preferredColorScheme(.dark)
            Spacer()
            Text("Data supplied by Weather API")
                .foregroundStyle(.white)
                .font(.system(size: 14))
        }
        .background(backgroundColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        }
    }
    
    func fetchWeather () async {
        let request = AF.request("http://api.weatherapi.com/v1/forecast.json?key=6f99958e722246f68a6221851241507&q=M1G3T8&days=3&aqi=no&alerts=no")
        request.responseDecodable(of: Weather.self) { response in
            switch response.result {
            case.success(let weather): 
                //dump(weather)
                cityName = weather.location.name
                results = weather.forecast.forecastday
                var index = 0
                if Date(timeIntervalSince1970: TimeInterval(results[0].date_epoch)).formatted(Date.FormatStyle().weekday(.abbreviated)) != Date().formatted(Date.FormatStyle().weekday(.abbreviated)) {
                    index = 1
                }
                currentTemp = Int(results[index].day.avgtemp_c)
                backgroundColor = getBackgroundColor(code: results[index].day.condition.code)
                weatherEmoji = getWeatherEmoji(code: results[index].day.condition.code)
                conditionText = results[index].day.condition.text
                loading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
