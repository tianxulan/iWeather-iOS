//
//  DetailViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DetailViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Los Angeles"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func twitterOnPressed(_ sender: UIButton) {
        print("twitter button Pressed")
        
    }
    

    
    
}
