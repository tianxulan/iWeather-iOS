//
//  DetailViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var navigation: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "twitter.svg")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,style: .done, target: self, action: #selector(DetailViewController.twitterOnPressed(_:)))
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
    
    @IBAction func twitterOnPressed(_ sender: UIButton) {
        print("twitter button Pressed")
        
    }
    

    
    
}
