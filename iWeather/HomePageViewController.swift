//
//  ViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/16/21.
//

import UIKit

class HomePageViewController: UIViewController, CurrentWeatherServiceDelegate{
    let searchController = UISearchController()
    // First sub outlets
    @IBOutlet weak var firstSubView: UIView!
    @IBOutlet weak var fsWeatherIcon: UIImageView!
    @IBOutlet weak var fsTemperature: UILabel!
    @IBOutlet weak var fsStatus: UILabel!
    @IBOutlet weak var fsCity: UILabel!

    // Second Sub Outlets
    @IBOutlet weak var ssHumidity: UILabel!
    @IBOutlet weak var ssWindSpeed: UILabel!
    @IBOutlet weak var ssVisibility: UILabel!
    @IBOutlet weak var ssPressure: UILabel!
    // Services
    var currentWeatherService = CurrentWeatherService()
    var dailyWeatherService = DailyWeatherService()
    // File-Scope variables
    var city = String()
    var homepageWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Set up first sub view
        firstSubView.layer.borderColor = UIColor.white.cgColor
        city = "Tucson"
        currentWeatherService.delegate = self
        loadHomepageData()
        
    }

    @IBAction func firstSubViewOnPressed(_ sender: UIButton)
    {
        //change view and transfer data
        let dayVC = DayViewController()
        dayVC.dayWeather = homepageWeather
        
    }
    func loadHomepageData()
    {
        print("load data for Homepage")
        currentWeatherService.fetchWeatherExample()
    }
    
    func didUpdateCurrentWeather(currentWeather: CurrentWeatherModel)
    {
        
        DispatchQueue.main.async {
            self.homepageWeather = currentWeather
            self.refreshPage()
        }
    }
    
    func refreshPage()
    {
        //first sub view
        self.fsWeatherIcon.image = UIImage(named: self.homepageWeather.getImageName())
        self.fsTemperature.text = self.homepageWeather.getTemperatureText()
        //TODO: update current location
        self.fsStatus.text = self.homepageWeather.getStatusText()
        //second sub view
        self.ssHumidity.text = self.homepageWeather.getHumidityText()
        self.ssWindSpeed.text = self.homepageWeather.getWindSpeedText()
        self.ssVisibility.text = self.homepageWeather.getVisibilityText()
        self.ssPressure.text = self.homepageWeather.getPressureText()
        //third table view
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HomepageToDetail") {
            let vc = segue.destination as! DetailViewController
            vc.title = self.city
            vc.detailWeather = homepageWeather
        }
    }
}

