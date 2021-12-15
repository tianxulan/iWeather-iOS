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
    var enterFromHomePage = true
    @IBOutlet weak var navigation: UINavigationItem!
    var city: String!
    var dayWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        //Static Setting up
        super.viewDidLoad()
        self.navigation.title = city
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
       
        self.humidityValue.text = self.dayWeather.getHumidityText()
        self.visibilityValue.text = self.dayWeather.getVisibilityText()
        self.cloudCoverValue.text = self.dayWeather.getCloudCoverText()
        self.UVIndexValue.text = self.dayWeather.getUVIndexText()
        
        
        
        
    }
    

    @IBAction func twitterButtonOnPressed(_ sender: Any) {
        
        let twitterText = "The current temperature at \(self.city!) is \(self.dayWeather.getTemperatureText()). The weather conditions are \(self.dayWeather.getStatusText()!)#CSCI571WeatherSearch"
        let EncodedTwitterText = twitterText.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=" + EncodedTwitterText!) else { print("can't produce URL"); return }
        
        UIApplication.shared.open(url)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonOnPressed(_ sender: Any) {
//        if(enterFromHomePage) {
//            self.performSegue(withIdentifier: "todayToHomePage", sender: self)
//        }
//        else
//        {
//            self.performSegue(withIdentifier: "todayToSearchResult", sender: self)
//        }
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }

}
