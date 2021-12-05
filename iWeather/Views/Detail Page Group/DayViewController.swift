//
//  DayViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DayViewController: UIViewController  {

    @IBOutlet var dayCell: [UIView]!
    @IBOutlet weak var windSpeedValue: UILabel!
    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var precipitationValue: UILabel!
    @IBOutlet weak var temperatureValue: UILabel!
    @IBOutlet weak var statusImagePath: UIImageView!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    @IBOutlet weak var cloudCoverValue: UILabel!
    @IBOutlet weak var UVIndexValue: UILabel!
    // file scope variable
    var dayWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        //Static Setting up
        super.viewDidLoad()
        for item in dayCell
        {
            item.layer.borderColor = UIColor.white.cgColor
        }
        // Tasks right after view is load
        refreshPage()
        
        
        
    }
    func refreshPage()
    {
        self.windSpeedValue.text = self.dayWeather.getWindSpeedText()
        self.pressureValue.text = self.dayWeather.getPressureText()
        self.precipitationValue.text = self.dayWeather.getPrecipitationProbabilityText()
        self.temperatureValue.text = self.dayWeather.getTemperatureText()
        self.statusImagePath.image = UIImage(named: self.dayWeather.getImageName())
        self.statusValue.text = self.dayWeather.getStatusText()
        self.statusValue.text = self.dayWeather.getStatusText()
        self.humidityValue.text = self.dayWeather.getHumidityText()
        self.visibilityValue.text = self.dayWeather.getVisibilityText()
        self.cloudCoverValue.text = self.dayWeather.getCloudCoverText()
        self.UVIndexValue.text = self.dayWeather.getUVIndexText()
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}