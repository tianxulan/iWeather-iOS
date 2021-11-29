//
//  weatherDataService.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/23/21.
//

import Foundation
protocol DailyWeatherServiceDelegate
{
    func didUpdateDailyWeather(dailyweatherModel:DailyWeatherModel)
}
struct DailyWeatherService
{
    let weatherURL = ""
    var delegate: DailyWeatherServiceDelegate?
    func fetchWeather(latitude: String, longitude: String)
    {
        if K.prodEnvironment
        {
           let urlString = "https://weather-node-330706.wn.r.appspot.com//search?latitude=\(latitude)&longitude=\(longitude)&type=daily"
            
           performRequest(urlString: urlString)
            
        }
        else
        {
            let urlString = "https://weather-node-330706.wn.r.appspot.com/dailyExampleProcessed.json"
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
                        self.delegate?.didUpdateDailyWeather(dailyweatherModel:weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> DailyWeatherModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode([DailyWeatherData].self, from: weatherData)
            var dailyWeatherCellsArray: Array<DailyWeatherCellModel> = []
        
            for decodedDataCell in decodedData {
                let date = String(decodedDataCell.startTime)
                let status = String(decodedDataCell.values.weatherCode)
                let sunriseTime = String(decodedDataCell.values.sunriseTime)
                let sunsetTime = String(decodedDataCell.values.sunsetTime)
                let temperatureMax = String(decodedDataCell.values.temperatureMax)
                let temperatureMin = String(decodedDataCell.values.temperatureMin)
                
                let dailyWeatherCell = DailyWeatherCellModel(date: date, weatherCode: status, sunriseTime: sunriseTime, sunsetTime: sunsetTime, temperatureMax: temperatureMax, temperatureMin: temperatureMin)
                dailyWeatherCellsArray.append(dailyWeatherCell)
            }
            let dailyWeatherModel = DailyWeatherModel(dayCells: dailyWeatherCellsArray)
            
            
            
            
            return dailyWeatherModel
            
        }catch
        {
            print(error)
            return nil
        }
        
        
    }
    
}
