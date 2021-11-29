//
//  Data.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/24/21.
//

import Foundation
extension Date {
   func formatToString(using formatter: DateFormatter) -> String {
      return formatter.string(from: self)
   }
}
extension DateFormatter {
 static let MMddyy: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC") //TimeZone.current
    formatter.dateFormat = "MM/dd/yy"
    return formatter
 }()
}

struct DailyWeatherData: Decodable
{
    let startTime: String
    let values: Values
}
struct Values: Decodable
{
    let weatherCode: Int
    let sunriseTime:String
    let sunsetTime:String
    let temperatureMax:Float
    let temperatureMin:Float
}

struct DailyWeatherModel
{
    var dayCells: Array<DailyWeatherCellModel>
}

struct DailyWeatherCellModel {
    let date:String
    let weatherCode: String
    let sunriseTime:String
    let sunsetTime:String
    let temperatureMax:String
    let temperatureMin:String
    
    func getDateFormatted() -> String
    {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let mydate = inputFormatter.date(from: date)!
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy"    //The OUT PUT FORMAT
        return outputFormatter.string(from: mydate)
    }
    
    func getWeatherImagePath() -> String
    {
        
        return WeatherCodeDescript[weatherCode]! + ".png"
    }
    func getSunriseTimeFormatted() -> String
    {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let mydate = inputFormatter.date(from: sunriseTime)!
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"    //The OUT PUT FORMAT
        
        return outputFormatter.string(from: mydate)

    }
    func getSunsetTimeFormatted() -> String
    {
        if sunsetTime == ""
        {
            return ""
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let mydate = inputFormatter.date(from: sunsetTime)!
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"    //The OUT PUT FORMAT
        return outputFormatter.string(from: mydate)

    }
    func getTemperatureMax() -> String
    {
        
        return temperatureMax
    }
    func getTemperatureMin() -> String
    {
        
        return temperatureMin
    }
}
