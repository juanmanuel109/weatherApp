import SwiftUI

struct WeatherDetails: View{
    @Binding var results: [ForecastDay]
    @Binding var cityName: String
    var index: Int
    
    var body: some View{
        ZStack{
            Color.init(getBackgroundColor(code: results[index].day.condition.code))
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .center){
                    
                }
            })
        }
        .navigationTitle("Weather Conditions")
    }
}


