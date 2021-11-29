//
//  weatherDataService.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/23/21.
//

import Foundation
protocol CurrentWeatherServiceDelegate
{
    func didUpdateCurrentWeather(currentWeather:CurrentWeatherModel)
}
struct CurrentWeatherService
{
    let weatherURL = ""
    var delegate: CurrentWeatherServiceDelegate?
    
    func fetchWeather(latitude:String, longtitude:String)
    {
        if K.prodEnvironment
        {
            let urlString = "https://weather-node-330706.wn.r.appspot.com//search?latitude=\(latitude)&longitude=\(longtitude)&type=current"
            performRequest(urlString: urlString)
            
        }
        else
        {
            let urlString = "https://weather-node-330706.wn.r.appspot.com/currentExampleProcessed.json"
            performRequest(urlString: urlString)
        }
        
    }
    func performRequest (urlString: String)
    {
        print("URL sent: " + urlString )
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
                    if let weather = self.parseJSON(weatherData: safeData)
                    {
                        self.delegate?.didUpdateCurrentWeather(currentWeather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> CurrentWeatherModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: weatherData)
            
            let temperature = String(decodedData.temperature)
            let status = String(decodedData.weatherCode)
            let humidity = String(decodedData.humidity)
            let windSpeed = String(decodedData.windSpeed)
            let visibility = String(decodedData.visibility)
            let pressure = String(decodedData.pressureSeaLevel)
            let precipitationProbability = String(decodedData.precipitationProbability)
            let cloudCover = String(decodedData.cloudCover)
            let UVIndex = String(decodedData.uvIndex)
            
            let currentWeather = CurrentWeatherModel(
                temperature:temperature,
                status:status,
                humidity:humidity,
                windSpeed:windSpeed,
                visibility:visibility,
                pressure: pressure,
                precipitationProbability:precipitationProbability,
                cloudCover:cloudCover,
                UVIndex:UVIndex
            )
            return currentWeather
            
        }catch
        {
            print(error)
            return nil
        }
        
        
    }
    
}
