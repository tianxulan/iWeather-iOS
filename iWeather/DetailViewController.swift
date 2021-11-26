//
//  DetailViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DetailViewController: UITabBarController {

    var detailWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //send data to day tab
        let dayVC = self.viewControllers![0] as! DayViewController
        dayVC.dayWeather = detailWeather
        //send data to weekly tab
        let weeklyVC = self.viewControllers![1] as! WeeklyViewController
        weeklyVC.weeklyWeather = detailWeather
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
        
    }
    

    
    
}
