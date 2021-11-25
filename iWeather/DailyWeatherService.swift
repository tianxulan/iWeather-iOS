//
//  weatherDataService.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/23/21.
//

import Foundation
struct DailyWeatherService
{
    let weatherURL = ""
    
    func fetchWeather(latitude: String, longitude: String, type: String)
    {
        
    }
    func fetchWeatherExample()
    {
        let urlString = "https://weather-node-330706.wn.r.appspot.com/dailyExampleProcessed.json"
        performRequest(urlString: urlString)
    }
    func performRequest (urlString: String)
    {
        if let url = URL(string:urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with:url) { (data,response,error) in
                if error != nil
                {
                    print(error!)
                    return
                }
                if let safeData = data
                {
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data)
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode([DailyWeatherData].self, from: weatherData)
            print(decodedData[0].values.sunriseTime)
        }catch
        {
            print(error)
        }
        
        
    }
    
}
