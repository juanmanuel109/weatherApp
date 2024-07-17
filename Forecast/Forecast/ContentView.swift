import SwiftUI
import Alamofire



struct ContentView: View {
    
    @State private var results = [ForecastDay]()
    @State var hourlyForecast=[Hour]()
    @State var query: String = ""
    @State var contentSize: CGSize = .zero
    @State var textFieldHeight = 15.0
    
    @State var backgroundColor = Color.init(red: 47/255, green: 79/255, blue: 79/255)
    @State var weatherEmoji = "🌨️"
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
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            .padding(.bottom, 1)
            Text("\(Date().formatted(date: .complete, time: .omitted))")
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            Text(weatherEmoji)
            .font(.system(size: 110))
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            Text("\(currentTemp)°C")
            .font(.system(size: 50))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            Text("\(conditionText)")
            .font(.system(size: 18))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            Spacer()
            Spacer()
            Spacer()
            Text("Hourly Forecast")
            .font(.system(size: 17))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
            .bold()
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    Spacer()
                    ForEach(hourlyForecast) { forecast in
                        VStack {
                            Text("\(getShortTime(time: forecast.time))")
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
                            Text("\(getWeatherEmoji(code: forecast.condition.code))")
                                .frame(width: 50, height: 14)
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
                            Text("\(Int(forecast.temp_c))°C")
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
                        }
                        .frame(width: 50, height: 50)
                    }
                    Spacer()
                }
                .background(Color.white.blur(radius: 75).opacity(0.35))
                .cornerRadius(15)
            }
            .padding(.top, .zero)
            .padding(.leading, 18)
            .padding(.trailing, 18)
            Spacer()
            Text(" 3 Day Forecast")
            .font(.system(size: 22))
            .foregroundStyle(.white)
            .bold()
            
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
