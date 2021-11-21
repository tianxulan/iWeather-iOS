//
//  ViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/16/21.
//

import UIKit

class ViewController: UIViewController {
    let searchController = UISearchController()
    // First sub outlets
    @IBOutlet weak var firstSubView: UIView!
    @IBOutlet weak var fsWeatherIcon: UIImageView!
    @IBOutlet weak var fsTemperature: UILabel!
    @IBOutlet weak var fsStatus: UILabel!
    
    @IBOutlet weak var fsCity: UILabel!
    
    // Second Sub Outlets
    
    @IBOutlet weak var secondSubView: UIStackView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Set up first sub view
        firstSubView.layer.borderColor = UIColor.white.cgColor
        fsTemperature.text = "1024°F"
        
    }

    @IBAction func firstSubViewOnPressed(_ sender: UIButton) {
        print("pressed")
    }
    
}

