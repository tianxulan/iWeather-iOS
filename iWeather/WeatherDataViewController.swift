//
//  WeatherDataViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class WeatherDataViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var precipitationValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var cloudCoverValue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.layer.borderColor = UIColor.white.cgColor
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

}
