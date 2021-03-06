//
//  CurrentWeatherModel.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/28/21.
//

import Foundation


struct CurrentWeatherData: Decodable
{
   
    let weatherCode: Int
    let temperature:Float
    let humidity:Float
    let pressureSeaLevel:Float
    let windSpeed:Float
    let visibility:Float
    let cloudCover:Float
    let precipitationProbability: Float
    let uvIndex:Float
}
struct CurrentWeatherModel
{
    
    let temperature:String
    let status:String
    let humidity:String
    let windSpeed:String
    let visibility:String
    let pressure: String
    let precipitationProbability:String
    let cloudCover:String
    let UVIndex:String
    
   
    func getTemperatureText() -> String
    {
        return temperature + "°F"
    }
    func getStatusText() -> String?
    {
        return WeatherCodeDescript[status]
    }
    func getImageName() -> String
    {
        return WeatherCodeDescript[status]! + ".png"
    }
    func getHumidityText() -> String
    {
        return humidity + " %"
    }
    func getWindSpeedText() -> String
    {
        return windSpeed + " mph"
    }
    func getVisibilityText() -> String
    {
        return visibility + " mi"
    }
    func getPressureText() -> String
    {
        return pressure + " inHg"
    }
    func getUVIndexText() -> String
    {
        return UVIndex
    }
    func getPrecipitationProbabilityText() -> String
    {
        return precipitationProbability + " %"
    }
    func getCloudCoverText() -> String
    {
        return cloudCover + " %"
    }
    func getHumidityInt() -> NSNumber
    {
        return NumberFormatter().number(from: humidity)!
        
    }
    func getPrecipitationInt() -> NSNumber
    {
        return NumberFormatter().number(from: precipitationProbability)!
    }
    func getCloudCoverInt() -> NSNumber
    {
        return NumberFormatter().number(from: cloudCover)!
    }
    
}
