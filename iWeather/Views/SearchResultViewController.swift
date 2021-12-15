//
//  ResultPageViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/20/21.
//

import UIKit
import CoreLocation
import SwiftSpinner
import Toast
class SearchResultViewController: UIViewController,CurrentWeatherServiceDelegate, UITableViewDataSource, UITableViewDelegate, DailyWeatherServiceDelegate{
    
    @IBOutlet weak var navigation: UINavigationItem!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dailyTable.dequeueReusableCell(withIdentifier: "ResultDayCell", for:indexPath) as! DailyCell
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
    
    //FavoriteButton
    @IBOutlet weak var favoriteButton: UIButton!
    // First Sub View
    @IBOutlet weak var firstSubView: UIView!
    @IBOutlet weak var fsWeatherIcon: UIImageView!
    @IBOutlet weak var fsTemperature: UILabel!
    @IBOutlet weak var fsStatus: UILabel!
    @IBOutlet weak var fsCity: UILabel!
    // Second Sub
    
    @IBOutlet weak var ssHumidity: UILabel!
    @IBOutlet weak var ssWindSpeed: UILabel!
    @IBOutlet weak var ssVisibility: UILabel!
    @IBOutlet weak var ssPressure: UILabel!
    // Third Sub
    @IBOutlet weak var dailyTable: UITableView!
    // Services
    var manuallyWeatherService = CurrentWeatherService()
    var dailyWeatherService = DailyWeatherService()
   
    // File-Scope variables
    var isCityFavorite:Bool!
    var city: String!
    var resultPageWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    var dailyWeather = DailyWeatherModel(dayCells:  [])
    var geolocation = GeoLocationModel(latitude: "", longitude: "")
    var addressDescription:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //set city
        // set title
        self.navigation.title = self.city
    
        self.fsCity.text = self.city
        // set current favorite state
        self.isCityFavorite = true
        // fist sub view
        firstSubView.layer.borderColor = UIColor.white.cgColor
        // TODO: get  geolocation of user input
       
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(self.addressDescription, completionHandler: {(placemarks, error) -> Void in
           if((error) != nil){
              print("Error", error)
           }
           if let placemark = placemarks?.first {
              let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
               self.geolocation.latitude = String(coordinates.latitude)
               self.geolocation.longitude = String(coordinates.longitude)
               self.LoadData()
              }
            })

        //Weather service
        
        manuallyWeatherService.delegate = self
        
        //Future seven days data
        dailyWeatherService.delegate = self
        
        
        //Table View
        dailyTable.dataSource = self
        dailyTable.delegate = self
        dailyTable.register(UINib(nibName: "DailyCell", bundle: Bundle.main), forCellReuseIdentifier: "ResultDayCell")
        
        //Load Data
        
    }
    

    @IBAction func backButtonOnPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func LoadData()
    {
        SwiftSpinner.show("Fetching Weather Details for " + self.city, animated: true)
        manuallyWeatherService.fetchWeather(latitude: geolocation.latitude, longtitude: geolocation.longitude)
        dailyWeatherService.fetchWeather(latitude: geolocation.latitude, longitude: geolocation.longitude)
    }
    func didUpdateCurrentWeather(currentWeather: CurrentWeatherModel) {
        
        DispatchQueue.main.async {
            self.resultPageWeather = currentWeather
            self.refreshPage()
        }
    }
    func didUpdateDailyWeather(dailyweatherModel: DailyWeatherModel) {
        DispatchQueue.main.async {
            self.dailyWeather = dailyweatherModel
            self.dailyTable.reloadData()
            
        }
    }
    
    
    func refreshPage()
    {
        
        //first sub view
        self.fsWeatherIcon.image = UIImage(named: self.resultPageWeather.getImageName())
        self.fsTemperature.text = self.resultPageWeather.getTemperatureText()
        //TODO: update current location
        self.fsStatus.text = self.resultPageWeather.getStatusText()
        //second sub view
        self.ssHumidity.text = self.resultPageWeather.getHumidityText()
        self.ssWindSpeed.text = self.resultPageWeather.getWindSpeedText()
        self.ssVisibility.text = self.resultPageWeather.getVisibilityText()
        self.ssPressure.text = self.resultPageWeather.getPressureText()
        //third table view
        SwiftSpinner.hide()
    }

    @IBAction func twitterButtonPressed(_ sender: Any) {
        let twitterText = "The current temperature at \(self.city!) is \(self.resultPageWeather.getTemperatureText()). The weather conditions are \(self.resultPageWeather.getStatusText()!)#CSCI571WeatherSearch"
        let EncodedTwitterText = twitterText.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=" + EncodedTwitterText!) else { print("can't produce URL"); return }
        
        UIApplication.shared.open(url)
    }
   
    @IBAction func favoriteButtonOnPressed(_ sender: UIButton)
    {
        if (isCityFavorite)
        {
            // UI
            favoriteButton.setImage(UIImage(named:"close-circle"), for: .normal)
            isCityFavorite = !isCityFavorite
            showToast(message: self.city + " was added to the Favorite List")
            //Store data to globallist
            globalFavoirteList.append(FavoriteModel(cityName: self.city, currentWeatherModel: resultPageWeather, dailyWeatherModel: dailyWeather))
            // Post Notification
            var info = [String: String]()
            info["operation"] = "add"
            info["location"] = self.city
            let name = Notification.Name(rawValue: K.favoriteNotificationKey )
            NotificationCenter.default.post(name: name, object: nil,userInfo: info)
            
        }
            
        else
        {
            favoriteButton.setImage(UIImage(named:"plus-circle"), for: .normal)
            isCityFavorite = !isCityFavorite
            showToast(message: self.city + " was removed from the Favorite List")
            // remove data from global list
            var viewControllerIndex = 0;
            for (index,item) in globalFavoirteList.enumerated()
            {
                if item.cityName == self.city
                {
                    viewControllerIndex = index
                }
            }
            globalFavoirteList.remove(at: viewControllerIndex)
            
            // Post Notification
            
            var info = [String: String]()
            info["operation"] = "delete"
            info["location"] = self.city
            let name = Notification.Name(rawValue: K.favoriteNotificationKey )
            NotificationCenter.default.post(name: name, object: nil,userInfo: info)
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ResultToDetail") {
            let vc = segue.destination as! DetailViewController
            vc.city = self.city
            vc.detailWeather = resultPageWeather
            vc.dailyWeather = dailyWeather
        }
    }
    
}
extension UIViewController
{
    func showToast(message:String)
    {
        self.view.makeToast(message)
    }
    
}
