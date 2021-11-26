//
//  ResultPageViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/20/21.
//

import UIKit

class ResultPageViewController: UIViewController {

    @IBOutlet weak var firstSubView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    var isCityFavorite:Bool!
    var city: String!
    var resultPageWeather = CurrentWeatherModel(temperature: "56", status: "1000", humidity: "56", windSpeed: "56", visibility: "56", pressure: "56", precipitationProbability: "56", cloudCover: "56", UVIndex: "56")
    override func viewDidLoad() {
        super.viewDidLoad()
        //set city
        self.city = "Las Vegas"
        // set title
        self.title = self.city
        // set current favorite state
        self.isCityFavorite = true
        firstSubView.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
