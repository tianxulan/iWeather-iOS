//
//  FavoritePageViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 12/7/21.
//

import UIKit
import SwiftSpinner
class FavoritePageViewController: UIViewController, AutocompleteServiceDelegate, UITableViewDataSource,UISearchBarDelegate, UITableViewDelegate{
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
        SwiftSpinner.show("Fetching Weather Details for " + filteredData[indexPath.row] )
        if tableView == placeTable
        {
            
            searchBar.endEditing(true)
            tableView.isHidden = true
            
            searchCity = filteredData[indexPath.row]
            searchCityDescrption = placeDescriptions[indexPath.row]
            // perform segue
          
                    // do stuff 42 seconds later
            
            self.performSegue(withIdentifier: "FavoritePageToResult", sender: self)
            
        }
        
    }

    
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

    // Second Sub Outlets
    @IBOutlet weak var ssHumidity: UILabel!
    @IBOutlet weak var ssWindSpeed: UILabel!
    @IBOutlet weak var ssVisibility: UILabel!
    @IBOutlet weak var ssPressure: UILabel!
    // Third Sub
    @IBOutlet weak var dailyTable: UITableView!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var fsCity: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    var city:String!
    // Service
    var autoCompleteService = AutocompleteService()
    // File-Scope variables
    var currentCity = String()
    var searchCity = String()
    var searchCityDescrption = String()
    var homepageWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    
    var dailyWeather = DailyWeatherModel(dayCells:  [])
    var autoComplete = AutocompleteModel(placeCells: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.backgroundColor = UIColor.clear.cgColor
        searchBar.searchBarStyle = .minimal // or default
        searchBar.setTextField(color: UIColor.white)//
        
        var viewControllerIndex = 0;
        for (index,item) in globalFavoirteList.enumerated()
        {
            if item.cityName == self.city
            {
                viewControllerIndex = index
            }
        }
        homepageWeather = globalFavoirteList[viewControllerIndex].currentWeatherModel
        dailyWeather = globalFavoirteList[viewControllerIndex].dailyWeatherModel
        
        placeTable.dataSource = self
        searchBar.delegate = self
        placeTable.delegate = self
        filteredData = []
        placeDescriptions = []
        placeTable.isHidden = true
        autoCompleteService.delegate = self
        
        firstSubView.layer.borderColor = UIColor.white.cgColor
        //Table View
        dailyTable.dataSource = self
        dailyTable.delegate = self
        dailyTable.register(UINib(nibName: "DailyCell", bundle: Bundle.main), forCellReuseIdentifier: "DayCell")
        // Do any additional setup after loading the view.
        refreshPage()
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
        self.performSegue(withIdentifier: "FavoritePageToDetail", sender: self)
        
    }
    func refreshPage()
    {
        //first sub view
        favoriteButton.setImage(UIImage(named:"close-circle"), for: .normal)
        self.fsWeatherIcon.image = UIImage(named: self.homepageWeather.getImageName())
        self.fsTemperature.text = self.homepageWeather.getTemperatureText()
        //TODO: update current location
        self.fsStatus.text = self.homepageWeather.getStatusText()
        //second sub view
        self.ssHumidity.text = self.homepageWeather.getHumidityText()
        self.ssWindSpeed.text = self.homepageWeather.getWindSpeedText()
        self.ssVisibility.text = self.homepageWeather.getVisibilityText()
        self.ssPressure.text = self.homepageWeather.getPressureText()
        self.fsCity.text = self.city
        //third table view
        SwiftSpinner.hide()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoritePageToDetail") {
            let vc = segue.destination as! DetailViewController
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            vc.city = self.currentCity
            vc.addressDescription = self.searchCityDescrption
            vc.detailWeather = homepageWeather
            vc.dailyWeather = dailyWeather
        }
        if (segue.identifier == "FavoritePageToResult")
        {
            let vc = segue.destination as! SearchResultViewController
            vc.city = self.searchCity
            vc.addressDescription = self.searchCityDescrption
        }
        if (segue.identifier == "FavoritePageToHomePage")
        {
            let vc = segue.destination as! HomePageViewController
            
            
        }
        if (segue.identifier == "FavoritePageToPageview")
        {
            let vc = segue.destination as! PageViewController
            LoadFromFavoritePage = true
            lastDeleteCity = self.city
        }
    }

    @IBAction func favoriteButtonOnPressed(_ sender: UIButton)
    {
        
        
        
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
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.performSegue(withIdentifier: "FavoritePageToPageview", sender: self)
        
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
