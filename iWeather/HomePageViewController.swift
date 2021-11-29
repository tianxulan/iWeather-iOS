//
//  ViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/16/21.
//

import UIKit
import CoreLocation
class HomePageViewController: UIViewController, CurrentWeatherServiceDelegate, DailyWeatherServiceDelegate{
    
    // Search Bar
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var placeTable: UITableView!
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
            "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
            "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
            "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
            "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    var filteredData: [String]!
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
    // Third Sub
    @IBOutlet weak var dailyTable: UITableView!
    // Services
    var currentWeatherService = CurrentWeatherService()
    var dailyWeatherService = DailyWeatherService()
    // File-Scope variables
    var city = String()
    var homepageWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    let locationManager = CLLocationManager()
    var dailyWeather = DailyWeatherModel(dayCells:  [])
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Search bar
        navigationItem.titleView = searchBar
//        searchBar.prompt = "Enter City Name..."
        
        placeTable.dataSource = self
        searchBar.delegate = self
        placeTable.delegate = self
        filteredData = data
        placeTable.isHidden = true
//        searchBar.endEditing(true)
        
        //Set up first sub view
        firstSubView.layer.borderColor = UIColor.white.cgColor
        
        
        //User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Weather service
        currentWeatherService.delegate = self
        loadHomepageData()
        
        //Future seven days data
        dailyWeatherService.delegate = self
        dailyWeatherService.fetchWeatherExample()
        
        //Table View
        dailyTable.dataSource = self
        dailyTable.delegate = self
        dailyTable.register(UINib(nibName: "DailyCell", bundle: Bundle.main), forCellReuseIdentifier: "DayCell")
        //put dummy data for tableview
//        for _ in 1...7
//        {
//            dailyWeather.dayCells.append(DailyWeatherCellModel(date: "", weatherCode: "", sunriseTime: "", sunsetTime: "", temperatureMax: "", temperatureMin: ""))
//        }
        
        
        
    }

    @IBAction func firstSubViewOnPressed(_ sender: UIButton)
    {
        //change view and transfer data
//        let dayVC = DayViewController()
//        dayVC.dayWeather = homepageWeather
        
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
    func didUpdateDailyWeather(dailyweatherModel: DailyWeatherModel) {
        DispatchQueue.main.async {
            
            self.dailyWeather = dailyweatherModel
            print("RUN")
            print(dailyweatherModel)
            self.dailyTable.reloadData()
            
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

// MARL: - CLLocationManagerDelegate
extension HomePageViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                        if error == nil {
                            if let firstLocation = placemarks?[0],
                                let cityName = firstLocation.locality {
                                // get the city name
                                self?.city = cityName
                                self?.fsCity.text = self?.city
                                
                            }
                        }
                    }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dailyTable
        {
            return 7
        }
        else
        {
            return filteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dailyTable
        {
            let cell = dailyTable.dequeueReusableCell(withIdentifier: "DayCell", for:indexPath) as! DailyCell
            if dailyWeather.dayCells.isEmpty
            {
                
                return cell
            }
            cell.date.text = dailyWeather.dayCells[indexPath.row].getDateFormatted()
            cell.sunriseTime.text = dailyWeather.dayCells[indexPath.row].getSunriseTimeFormatted()
            cell.statusImage.image = UIImage(named: dailyWeather.dayCells[indexPath.row].getWeatherImagePath())
            cell.sunsetTime.text = dailyWeather.dayCells[indexPath.row].getSunsetTimeFormatted()
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = filteredData[indexPath.row]
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == placeTable
        {
            print(indexPath.row)
            searchBar.endEditing(true)
            tableView.isHidden = true
        }
        
    }

    
    
}

extension HomePageViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            placeTable.reloadData()
        }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        placeTable.isHidden = false
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        placeTable.isHidden = true
    }
}
