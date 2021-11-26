//
//  WeeklyViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class WeeklyViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var statusImagePath: UIImageView!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var temperatureValue: UILabel!
    //file scope variable
    var weeklyWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        //static setting
        titleView.layer.borderColor = UIColor.white.cgColor
        //operation right after loading view
        refreshPage()
    }
    func refreshPage()
    {
        self.statusImagePath.image = UIImage(named: self.weeklyWeather.getImageName())
        self.temperatureValue.text = self.weeklyWeather.getTemperatureText()
        self.statusValue.text = self.weeklyWeather.getStatusText()
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
