//
//  DayViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DayViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in dayCell
        {
            item.layer.borderColor = UIColor.white.cgColor
        }
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
