//
//  DetailViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DetailViewController: UITabBarController {

    var detailWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    var dailyWeather = DailyWeatherModel(dayCells:  [])
    var addressDescription:String!
    var city:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //send data to day tab
        let dayVC = self.viewControllers![0] as! DayViewController
        dayVC.dayWeather = detailWeather
        dayVC.city = city
        //send data to weekly tab
        let weeklyVC = self.viewControllers![1] as! WeeklyViewController
        weeklyVC.weeklyWeather = detailWeather
        weeklyVC.dailyWeather = dailyWeather
        weeklyVC.city = city
        //send data to weatherData tab
        let weatherDataVC = self.viewControllers![2] as! WeatherDataViewController
        weatherDataVC.city = city
        weatherDataVC.weatherDataWeather = detailWeather
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func twitterOnPressed(_ sender: UIButton) {
        print("twitter button Pressed")
        
        let twitterText = "The current temperature at \(self.title!) is \(self.detailWeather.getTemperatureText()). The weather conditions are \(self.detailWeather.getStatusText()!)#CSCI571WeatherSearch"
        let EncodedTwitterText = twitterText.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=" + EncodedTwitterText!) else { print("can't produce URL"); return }
        
        UIApplication.shared.open(url)
        
    }
    

    
    
}
