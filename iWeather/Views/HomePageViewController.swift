//
//  ViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/16/21.
//

import UIKit
import CoreLocation
import SwiftSpinner

var globalFirstTimeLoadHomePage = true
var homepageWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
var LoadFromFavoritePage:Bool = false
var lastDeleteCity:String!
var currentDailyWeather = DailyWeatherModel(dayCells:  [])
var currentCity:String!
class HomePageViewController: UIViewController, CurrentWeatherServiceDelegate, DailyWeatherServiceDelegate, AutocompleteServiceDelegate{
    
    // Search Bar
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var placeTable: UITableView!
    
    
    var filteredData: [String]!
    var placeDescriptions: [String]!
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
    var autoCompleteService = AutocompleteService()
    
    // File-Scope variables
    
    var searchCity = String()
    var searchCityDescrption = String()
    
    let locationManager = CLLocationManager()
    
    var autoComplete = AutocompleteModel(placeCells: [])
    var currentGeolocation = GeoLocationModel(latitude: "", longitude: "")
    var firstTimeLoaded = true
    let notification = Notification.Name(rawValue: K.favoriteNotificationKey)
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Search bar
//        let controller= storyboard!.instantiateViewController(withIdentifier: "")
        
        
        
        navigationItem.titleView = searchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.backgroundColor = UIColor.clear.cgColor
        searchBar.searchBarStyle = .minimal // or default
        searchBar.setTextField(color: UIColor.white)//        searchBar.prompt = "Enter City Name..."
        //Set up first sub view
        firstSubView.layer.borderColor = UIColor.white.cgColor
        if (LoadFromFavoritePage)
        {
            showToast(message: lastDeleteCity + " was removed from the Favorite List")
            refreshPage()
            LoadFromFavoritePage = false
        }
        
        placeTable.dataSource = self
        searchBar.delegate = self
        placeTable.delegate = self
        filteredData = []
        placeDescriptions = []
        placeTable.isHidden = true
        autoCompleteService.delegate = self
        
//        searchBar.endEditing(true)
        
        
        
        
        //User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if globalFirstTimeLoadHomePage{
            globalFirstTimeLoadHomePage = false
            locationManager.requestLocation()
        }
        
            
        
        
        
        //Weather service
        currentWeatherService.delegate = self
        
        
        //Future seven days data
        dailyWeatherService.delegate = self
        
        
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
    
    
    func didUpdateAutocomplete(autocompletemodel: AutocompleteModel) {
        DispatchQueue.main.async {
            self.autoComplete = autocompletemodel
            self.filteredData = []
            self.placeDescriptions = []
            for item in self.autoComplete.placeCells
            {
                self.filteredData.append(item.cityName)
                self.placeDescriptions.append(item.cityDescription)
            }
            
            self.placeTable.reloadData()
        }
    }

    @IBAction func firstSubViewOnPressed(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "HomepageToDetail", sender: self)
        
    }
    func loadHomepageData(currentLocation: GeoLocationModel)
    {
        
        
        
        currentWeatherService.fetchWeather(latitude: currentLocation.latitude,longtitude: currentLocation.longitude)
        dailyWeatherService.fetchWeather(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
    }
    
    func didUpdateCurrentWeather(currentWeather: CurrentWeatherModel)
    {
        
        DispatchQueue.main.async {
            homepageWeather = currentWeather
            
                self.refreshPage()
            
            
        }
    }
    func didUpdateDailyWeather(dailyweatherModel: DailyWeatherModel) {
        DispatchQueue.main.async {
            currentDailyWeather = dailyweatherModel
            self.dailyTable.reloadData()
            
        }
    }
    
    func refreshPage()
    {
        
        //first sub view
        self.fsWeatherIcon.image = UIImage(named: homepageWeather.getImageName())
        self.fsTemperature.text = homepageWeather.getTemperatureText()
        //TODO: update current location
        self.fsStatus.text = homepageWeather.getStatusText()
        self.fsCity.text = currentCity
        //second sub view
        self.ssHumidity.text = homepageWeather.getHumidityText()
        self.ssWindSpeed.text = homepageWeather.getWindSpeedText()
        self.ssVisibility.text = homepageWeather.getVisibilityText()
        self.ssPressure.text = homepageWeather.getPressureText()
        
        //third table view
        SwiftSpinner.hide()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HomepageToDetail") {
            let vc = segue.destination as! DetailViewController
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            vc.city = currentCity
            vc.addressDescription = self.searchCityDescrption
            vc.detailWeather = homepageWeather
            vc.dailyWeather = currentDailyWeather
        }
        if (segue.identifier == "HomepageToResult")
        {
            let vc = segue.destination as! SearchResultViewController
            vc.city = self.searchCity
            vc.addressDescription = self.searchCityDescrption
        }
    }
    
}

// MARL: - CLLocationManagerDelegate
extension HomePageViewController:CLLocationManagerDelegate
{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        SwiftSpinner.show("Loading", animated: true)
        if let location = locations.last
        {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.currentGeolocation.latitude = String(lat)
            self.currentGeolocation.longitude = String(lon)
            
                self.loadHomepageData(currentLocation: self.currentGeolocation)
            
            
            
            
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                        if error == nil {
                            if let firstLocation = placemarks?[0],
                                let cityName = firstLocation.locality {
                                // get the city name
                                currentCity = cityName
                                self?.fsCity.text = currentCity
                                
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
            if currentDailyWeather.dayCells.isEmpty
            {
                
                return cell
            }
            cell.date.text = currentDailyWeather.dayCells[indexPath.row].getDateFormatted()
            cell.sunriseTime.text = currentDailyWeather.dayCells[indexPath.row].getSunriseTimeFormatted()
            cell.statusImage.image = UIImage(named: currentDailyWeather.dayCells[indexPath.row].getWeatherImagePath())
            cell.sunsetTime.text = currentDailyWeather.dayCells[indexPath.row].getSunsetTimeFormatted()
            
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
            SwiftSpinner.show("Fetching Weather Details for " + filteredData[indexPath.row] )
            searchBar.endEditing(true)
            tableView.isHidden = true
            
            searchCity = filteredData[indexPath.row]
            searchCityDescrption = placeDescriptions[indexPath.row]
            // perform segue
          
                    // do stuff 42 seconds later
            
            self.performSegue(withIdentifier: "HomepageToResult", sender: self)
            
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
            placeTable.isHidden = false
            self.autoCompleteService.fetchAutocomplete(keyword:searchBar.text! )
            filteredData = searchText.isEmpty ? filteredData : filteredData.filter { (item: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            placeTable.reloadData()
        }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        placeTable.isHidden = true
    }

}
extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
