//
//  FavoritePageModel.swift
//  iWeather
//
//  Created by Tianxu Lan on 12/7/21.
//

import Foundation
import UIKit
struct PageViewModel {
    var VC:UIViewController
    var cityName:String
}
struct FavoriteModel
{
    var cityName: String
    var currentWeatherModel: CurrentWeatherModel
    var dailyWeatherModel: DailyWeatherModel
}
