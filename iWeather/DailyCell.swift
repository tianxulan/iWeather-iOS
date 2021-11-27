//
//  DailyCell.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/27/21.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var dayCellView: UIView!
    @IBOutlet  var date: UILabel!
    
    @IBOutlet weak var sunriseTime: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var sunsetTime: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
