//
//  ResultPageViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/20/21.
//

import UIKit
import CoreLocation

class SearchResultViewController: UIViewController,CurrentWeatherServiceDelegate, UITableViewDataSource, UITableViewDelegate, DailyWeatherServiceDelegate{
    
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
        self.title = self.city
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
    }

    @IBAction func twitterButtonOnPressed(_ sender: UIButton)
    {
        print("Twitter button presssed @Result Page")
    }
    @IBAction func favoriteButtonOnPressed(_ sender: UIButton)
    {
        if (isCityFavorite)
        {
            favoriteButton.setImage(UIImage(named:"close-circle"), for: .normal)
            isCityFavorite = !isCityFavorite
            showToast(message: self.city + " was added to the Favorite List")        }
        else
        {
            favoriteButton.setImage(UIImage(named:"plus-circle"), for: .normal)
            isCityFavorite = !isCityFavorite
            showToast(message: self.city + " was removed from the Favorite List")
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ResultToDetail") {
            let vc = segue.destination as! DetailViewController
            vc.title = self.city
            vc.detailWeather = resultPageWeather
        }
    }
    
}
extension UIViewController
{
    func showToast(message:String)
    {
        let toastLabel = UILabel(frame: CGRect(x:45, y:self.view.frame.height-100, width:300, height:60))
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay:1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }){(isCompleted) in
            toastLabel.removeFromSuperview()
            
        }
    }
    
}
